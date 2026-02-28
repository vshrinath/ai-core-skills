# CI/CD Pipelines — GitHub Actions

**Philosophy:** Automate testing, building, and deployment. Humans review code, machines deploy it.

## When to use this guide
- Setting up GitHub Actions workflows
- Configuring automated testing and deployment
- Managing secrets in CI/CD
- Implementing deployment gates and approvals
- Automating release processes

---

## Core Principles

### 1. Test Before Deploy

Every deployment must pass:
- Unit tests
- Integration tests
- Linting and code quality checks
- Security scans (dependencies, secrets)

### 2. Staging Before Production

- Merge to `main` → auto-deploy to staging
- Tag release → auto-deploy to production (with approval)
- Never deploy directly to production without staging validation

### 3. Rollback Plan

Every deployment must have a rollback strategy:
- Previous Docker image tagged and available
- Database migrations are backward-compatible
- Feature flags for risky changes

### 4. Secrets Management

- Never commit secrets to repo
- Use GitHub Secrets for sensitive values
- Rotate secrets quarterly
- Audit secret access logs

---

## Workflow Structure

### File Layout

```
.github/
└── workflows/
    ├── test.yml           # Run tests on every PR
    ├── deploy-staging.yml # Deploy to staging on merge to main
    └── deploy-prod.yml    # Deploy to production on tag
```

---

## 1. Test Workflow (test.yml)

**Trigger:** Every push, every PR

```yaml
name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: testpass
          MYSQL_DATABASE: testdb
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
      
      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          pip install --upgrade pip
          pip install -r requirements.txt
          pip install -r requirements-ci.txt
      
      - name: Run linting
        run: |
          ruff check .
          black --check .
      
      - name: Run type checking
        run: mypy .
      
      - name: Run tests
        env:
          DATABASE_URL: mysql://root:testpass@127.0.0.1:3306/testdb
          REDIS_URL: redis://127.0.0.1:6379/0
          SECRET_KEY: test-secret-key-for-ci
          DJANGO_SETTINGS_MODULE: myproject.settings.test
        run: |
          pytest --cov=. --cov-report=xml --cov-report=term
      
      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml
          fail_ci_if_error: false
      
      - name: Security check (dependencies)
        run: |
          pip-audit
      
      - name: Security check (secrets)
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          head: HEAD
```

### Key Points

- **Services:** MySQL and Redis run as containers
- **Caching:** pip cache speeds up subsequent runs
- **Coverage:** Track test coverage over time
- **Security:** Check for vulnerable dependencies and leaked secrets
- **Fail fast:** If tests fail, don't proceed to deployment

---

## 2. Deploy to Staging (deploy-staging.yml)

**Trigger:** Merge to `main` branch

```yaml
name: Deploy to Staging

on:
  push:
    branches: [main]

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: myapp-staging
  ECS_SERVICE: myapp-staging-service
  ECS_CLUSTER: myapp-staging-cluster
  ECS_TASK_DEFINITION: myapp-staging-task

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2
      
      - name: Build, tag, and push image to ECR
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          echo "image=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG" >> $GITHUB_OUTPUT
      
      - name: Download task definition
        run: |
          aws ecs describe-task-definition \
            --task-definition ${{ env.ECS_TASK_DEFINITION }} \
            --query taskDefinition > task-definition.json
      
      - name: Update task definition with new image
        id: task-def
        uses: aws-actions/amazon-ecs-render-task-definition@v1
        with:
          task-definition: task-definition.json
          container-name: myapp
          image: ${{ steps.build-image.outputs.image }}
      
      - name: Deploy to ECS
        uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          task-definition: ${{ steps.task-def.outputs.task-definition }}
          service: ${{ env.ECS_SERVICE }}
          cluster: ${{ env.ECS_CLUSTER }}
          wait-for-service-stability: true
      
      - name: Run database migrations
        run: |
          aws ecs run-task \
            --cluster ${{ env.ECS_CLUSTER }} \
            --task-definition ${{ env.ECS_TASK_DEFINITION }} \
            --launch-type FARGATE \
            --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx],securityGroups=[sg-xxx],assignPublicIp=ENABLED}" \
            --overrides '{"containerOverrides":[{"name":"myapp","command":["python","manage.py","migrate"]}]}'
      
      - name: Verify deployment
        run: |
          curl -f https://staging.example.com/health/ || exit 1
      
      - name: Notify Slack
        if: always()
        uses: slackapi/slack-github-action@v1
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
          payload: |
            {
              "text": "Staging deployment ${{ job.status }}: ${{ github.sha }}"
            }
```

### Key Points

- **Automatic:** Deploys on every merge to main
- **Migrations:** Run before new code is deployed
- **Health check:** Verify deployment succeeded
- **Notifications:** Alert team on Slack

---

## 3. Deploy to Production (deploy-prod.yml)

**Trigger:** Git tag (e.g., `v1.0.0`)

```yaml
name: Deploy to Production

on:
  push:
    tags:
      - 'v*.*.*'

env:
  AWS_REGION: us-east-1
  ECR_REPOSITORY: myapp-production
  ECS_SERVICE: myapp-production-service
  ECS_CLUSTER: myapp-production-cluster
  ECS_TASK_DEFINITION: myapp-production-task

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Extract version from tag
        id: version
        run: echo "VERSION=${GITHUB_REF#refs/tags/}" >> $GITHUB_OUTPUT
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID_PROD }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY_PROD }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2
      
      - name: Build, tag, and push image to ECR
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ steps.version.outputs.VERSION }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker tag $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:latest
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest
          echo "image=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG" >> $GITHUB_OUTPUT
      
      - name: Download task definition
        run: |
          aws ecs describe-task-definition \
            --task-definition ${{ env.ECS_TASK_DEFINITION }} \
            --query taskDefinition > task-definition.json
      
      - name: Update task definition with new image
        id: task-def
        uses: aws-actions/amazon-ecs-render-task-definition@v1
        with:
          task-definition: task-definition.json
          container-name: myapp
          image: ${{ steps.build-image.outputs.image }}
      
      - name: Deploy to ECS
        uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          task-definition: ${{ steps.task-def.outputs.task-definition }}
          service: ${{ env.ECS_SERVICE }}
          cluster: ${{ env.ECS_CLUSTER }}
          wait-for-service-stability: true
      
      - name: Run database migrations
        run: |
          aws ecs run-task \
            --cluster ${{ env.ECS_CLUSTER }} \
            --task-definition ${{ env.ECS_TASK_DEFINITION }} \
            --launch-type FARGATE \
            --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx],securityGroups=[sg-xxx],assignPublicIp=ENABLED}" \
            --overrides '{"containerOverrides":[{"name":"myapp","command":["python","manage.py","migrate"]}]}'
      
      - name: Verify deployment
        run: |
          curl -f https://example.com/health/ || exit 1
      
      - name: Create GitHub Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ steps.version.outputs.VERSION }}
          release_name: Release ${{ steps.version.outputs.VERSION }}
          body: |
            See [CHANGELOG.md](https://github.com/${{ github.repository }}/blob/main/CHANGELOG.md) for details.
          draft: false
          prerelease: false
      
      - name: Notify Slack
        if: always()
        uses: slackapi/slack-github-action@v1
        with:
          webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
          payload: |
            {
              "text": "🚀 Production deployment ${{ job.status }}: ${{ steps.version.outputs.VERSION }}"
            }
```

### Key Points

- **Manual trigger:** Only deploys when you create a tag
- **Environment protection:** Requires approval in GitHub settings
- **Versioned images:** Tags image with version number
- **GitHub Release:** Creates release notes automatically

---

## 4. Secrets Management

### Required Secrets (GitHub Settings → Secrets)

**Staging:**
- `AWS_ACCESS_KEY_ID` — AWS credentials for staging
- `AWS_SECRET_ACCESS_KEY`

**Production:**
- `AWS_ACCESS_KEY_ID_PROD` — AWS credentials for production
- `AWS_SECRET_ACCESS_KEY_PROD`

**Shared:**
- `SLACK_WEBHOOK_URL` — For deployment notifications
- `CODECOV_TOKEN` — For coverage reporting

### How to Add Secrets

1. Go to GitHub repo → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `AWS_ACCESS_KEY_ID`
4. Value: (paste actual key)
5. Click "Add secret"

### Secret Rotation

- Rotate AWS keys quarterly
- Rotate database passwords annually
- Rotate API keys when team members leave
- Use AWS IAM roles instead of keys when possible

---

## 5. Environment Protection Rules

### GitHub Settings → Environments

**Staging:**
- No protection rules (auto-deploy)
- Deployment branch: `main` only

**Production:**
- Required reviewers: 1-2 people
- Wait timer: 5 minutes (time to cancel if needed)
- Deployment branch: tags only (`v*.*.*`)

---

## 6. Deployment Workflow

### Normal Flow

```
1. Developer creates PR
   ↓
2. Tests run automatically (test.yml)
   ↓
3. Code review + approval
   ↓
4. Merge to main
   ↓
5. Auto-deploy to staging (deploy-staging.yml)
   ↓
6. Manual testing on staging
   ↓
7. Create git tag (v1.2.3)
   ↓
8. Approval required (GitHub environment protection)
   ↓
9. Deploy to production (deploy-prod.yml)
   ↓
10. Verify production health check
```

### Hotfix Flow

```
1. Create hotfix branch from main
   ↓
2. Fix bug, commit
   ↓
3. Create PR, tests run
   ↓
4. Fast-track review
   ↓
5. Merge to main → staging
   ↓
6. Verify fix on staging
   ↓
7. Tag immediately (v1.2.4)
   ↓
8. Deploy to production
```

---

## 7. Rollback Procedure

### Option 1: Revert to Previous Image

```bash
# Find previous task definition
aws ecs describe-services \
  --cluster myapp-production-cluster \
  --services myapp-production-service

# Update service to previous task definition
aws ecs update-service \
  --cluster myapp-production-cluster \
  --service myapp-production-service \
  --task-definition myapp-production-task:42  # Previous revision
```

### Option 2: Deploy Previous Tag

```bash
# Delete bad tag
git tag -d v1.2.3
git push origin :refs/tags/v1.2.3

# Re-tag previous commit
git tag v1.2.3 <previous-commit-sha>
git push origin v1.2.3

# GitHub Actions will deploy previous version
```

### Option 3: Emergency Rollback (Manual)

```bash
# SSH into production server or use AWS console
# Manually revert to previous Docker image
docker pull myapp:v1.2.2
docker stop myapp-current
docker run -d --name myapp-current myapp:v1.2.2
```

---

## 8. Monitoring Deployments

### What to Watch

**During deployment (0-5 minutes):**
- Health check endpoint responds
- No 5xx errors in logs
- Container starts successfully

**After deployment (5-30 minutes):**
- Error rate < 1%
- Response time p95 < 500ms
- No spike in error logs
- External integrations working (email, search, auth)

**Long-term (1-24 hours):**
- Memory usage stable
- CPU usage normal
- Database query performance unchanged
- User-reported issues

### Rollback Triggers

Rollback immediately if:
- Error rate > 5% for 5 minutes
- Health check fails
- Critical feature broken (login, checkout, core workflow)
- Database migration failed

Investigate (don't rollback yet) if:
- Error rate 1-5%
- Performance degradation < 20%
- Non-critical feature broken

---

## 9. Common Issues

### Issue: Tests pass locally, fail in CI

**Cause:** Different Python version, missing system dependencies

**Solution:**
```yaml
- name: Set up Python
  uses: actions/setup-python@v5
  with:
    python-version: '3.11'  # Match production exactly
```

### Issue: Docker build fails in CI (out of disk space)

**Solution:** Clean up old images
```yaml
- name: Clean up Docker
  run: docker system prune -af
```

### Issue: Secrets not available in workflow

**Solution:** Check secret name matches exactly (case-sensitive)
```yaml
env:
  AWS_KEY: ${{ secrets.AWS_ACCESS_KEY_ID }}  # Must match GitHub secret name
```

### Issue: Deployment succeeds but app doesn't work

**Cause:** Environment variables not set in ECS task definition

**Solution:** Add env vars to task definition JSON or use AWS Parameter Store

---

## 10. Best Practices

### Do:
- ✅ Run tests on every PR
- ✅ Deploy to staging automatically
- ✅ Require approval for production
- ✅ Tag production releases
- ✅ Monitor deployments for 30 minutes
- ✅ Have a rollback plan
- ✅ Notify team of deployments

### Don't:
- ❌ Deploy directly to production without staging
- ❌ Skip tests to "deploy faster"
- ❌ Commit secrets to repo
- ❌ Deploy on Friday afternoon
- ❌ Deploy without checking staging first
- ❌ Ignore failed health checks

---

## Further Reading

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS ECS Deployment](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-types.html)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

# @confidence-scoring — When to Ask for Help

**Philosophy:** Know what you don't know. Confidence without competence is dangerous; competence without confidence wastes time.

## When to invoke
- Before starting any task
- After completing implementation
- When encountering unexpected behavior
- When making architectural decisions
- When uncertain about approach

## Responsibilities
- Assess confidence level for each task
- Identify knowledge gaps
- Determine when to ask for clarification
- Escalate when confidence is too low
- Document uncertainty for review

---

## Confidence Levels

### High Confidence (90-100%)

**Characteristics:**
- Similar to previous work
- Clear requirements
- Well-understood tech stack
- Straightforward implementation
- No ambiguity

**Action:** Proceed autonomously

**Example:**
```
Task: Add a new field to existing model
Confidence: 95%

Reasoning:
✓ Done this many times before
✓ Clear requirement: "Add 'bio' field to User model"
✓ Know exactly how to do it
✓ Can verify with tests

Proceed: Yes
```

### Medium Confidence (70-89%)

**Characteristics:**
- Some new territory
- Minor ambiguity in requirements
- Familiar tech but new pattern
- Multiple valid approaches
- Some uncertainty about edge cases

**Action:** Proceed with caution, document assumptions

**Example:**
```
Task: Implement rate limiting on API endpoint
Confidence: 75%

Reasoning:
✓ Understand the concept
✓ Know the library (django-ratelimit)
? Not sure about exact limits (100/hour? 1000/hour?)
? Not sure if per-user or per-IP

Proceed: Yes, but document assumptions
Assumptions:
- 100 requests per hour per user
- Rate limit by authenticated user ID
- Return 429 status code when exceeded

Ask for review: Yes (before merging)
```

### Low Confidence (50-69%)

**Characteristics:**
- Unfamiliar territory
- Significant ambiguity
- Multiple unknowns
- Complex integration
- High risk of being wrong

**Action:** Ask for clarification before proceeding

**Example:**
```
Task: Integrate payment gateway
Confidence: 60%

Reasoning:
✓ Understand basic flow
? Never integrated this specific gateway
? Not sure about webhook handling
? Not sure about refund flow
? Security implications unclear

Proceed: No
Ask for clarification:
1. Which payment gateway? (Stripe, PayPal, Square?)
2. What payment methods? (Card, bank transfer, both?)
3. Do we need to handle refunds?
4. What's the webhook URL structure?
5. Any compliance requirements? (PCI-DSS)
```

### Very Low Confidence (< 50%)

**Characteristics:**
- Completely unfamiliar
- Vague requirements
- No clear approach
- High complexity
- Multiple dependencies

**Action:** Stop and ask for help

**Example:**
```
Task: "Make the system faster"
Confidence: 30%

Reasoning:
? What part of the system?
? How much faster?
? What's the current performance?
? What's the target performance?
? What's the budget (time/resources)?

Proceed: No
Ask for clarification:
1. Which specific operation is slow?
2. What's the current performance? (measurements)
3. What's the target performance?
4. What's the acceptable trade-off? (complexity, cost)
5. Are there any constraints? (can't change database, etc.)
```

---

## Confidence Assessment Framework

### 1. Requirement Clarity

```
Score 0-10:

10: Crystal clear, no ambiguity
- "Add 'email' field to User model, max 255 chars, unique, required"

7: Mostly clear, minor ambiguity
- "Add email field to User model"
  (Unclear: max length? unique? required?)

5: Significant ambiguity
- "Add user contact information"
  (Unclear: email? phone? address? all of them?)

2: Very vague
- "Improve user management"
  (Unclear: what aspect? how? why?)
```

### 2. Technical Familiarity

```
Score 0-10:

10: Done this exact thing before
- "Add field to Django model" (done 100+ times)

7: Done similar things
- "Add field with custom validation" (done validation, not this exact type)

5: Understand concept, never implemented
- "Add full-text search" (know what it is, never set it up)

2: Completely new
- "Implement blockchain integration" (no idea where to start)
```

### 3. Complexity

```
Score 0-10:

10: Trivial (< 10 lines of code)
- Add a constant

7: Simple (< 50 lines)
- Add a model field with validation

5: Medium (< 200 lines)
- Add API endpoint with authentication

2: Complex (> 200 lines or multiple files)
- Implement entire authentication system
```

### 4. Risk Level

```
Score 0-10:

10: No risk (easily reversible)
- Add a new optional field

7: Low risk (reversible with effort)
- Modify existing field (can rollback migration)

5: Medium risk (hard to reverse)
- Change database schema with data migration

2: High risk (irreversible or critical)
- Delete production data
- Change authentication system
```

### Overall Confidence Formula

Each dimension is scored 0–10. Complexity and Risk are inverted (low complexity = high confidence).

```
Confidence % = (Clarity + Familiarity + (10 - Complexity) + (10 - Risk)) / 40 × 100

Example:
Clarity:    8  (mostly clear)
Familiarity: 7  (done similar things)
Complexity:  6  → inverted: 10 - 6 = 4
Risk:        8  → inverted: 10 - 8 = 2

Confidence = (8 + 7 + 4 + 2) / 40 × 100 = 21 / 40 × 100 = 52.5%

Action: Low confidence (< 70%) → Ask for clarification before proceeding
```

---

## When to Ask for Clarification

### Always Ask When:
- Confidence < 70%
- Requirements are vague
- Multiple valid interpretations exist
- High risk of breaking production
- Irreversible changes (data deletion, schema changes)
- Security implications unclear
- Performance requirements unclear

### Questions to Ask:

**For vague requirements:**
```
"I understand you want [X], but I need clarification on:
1. [Specific question 1]
2. [Specific question 2]
3. [Specific question 3]

My current understanding is [assumption]. Is this correct?"
```

**For technical uncertainty:**
```
"I can implement this, but I'm uncertain about:
1. [Technical decision 1] - Options: A, B, C
2. [Technical decision 2] - Options: X, Y, Z

My recommendation is [option] because [reason]. Does this align with your expectations?"
```

**For risk assessment:**
```
"This change has the following risks:
1. [Risk 1] - Mitigation: [how to reduce]
2. [Risk 2] - Mitigation: [how to reduce]

Should I proceed, or would you like to review the approach first?"
```

---

## Confidence in Implementation

### After Completing Work

**High confidence (90%+):**
```
✓ All tests pass
✓ Code follows conventions
✓ No obvious bugs
✓ Edge cases handled
✓ Documentation updated

Action: Ready for review
```

**Medium confidence (70-89%):**
```
✓ Tests pass
✓ Code works for happy path
? Some edge cases might be missed
? Performance might be suboptimal

Action: Ready for review, flag uncertainties
Note: "I'm 80% confident this handles all cases. Please review edge case handling for [specific scenario]."
```

**Low confidence (< 70%):**
```
✓ Tests pass
? Not sure if this is the right approach
? Might be missing something
? Feels overly complex

Action: Ask for review before proceeding
Note: "I've implemented this, but I'm only 60% confident. Can you review the approach before I continue?"
```

---

## Documenting Uncertainty

### In Code Comments

```python
# TODO: Confidence 70% - Assuming rate limit is per-user, not per-IP
# If this is wrong, change to per-IP rate limiting
@ratelimit(key='user', rate='100/h')
def api_endpoint(request):
    pass
```

### In Commit Messages

```
feat: add rate limiting to API endpoints

Implemented per-user rate limiting at 100 requests/hour.

Assumptions:
- Rate limit is per authenticated user (not per IP)
- 100/hour is acceptable (not specified in requirements)
- 429 status code is appropriate response

Confidence: 75%
Please review assumptions before merging.
```

### In Pull Request Description

```markdown
## Changes
- Added rate limiting to API endpoints

## Confidence Level: 75%

## Assumptions Made
1. Rate limit is per-user (not per-IP)
2. 100 requests/hour is acceptable
3. Unauthenticated requests are not rate-limited

## Questions for Reviewer
1. Is 100/hour the right limit?
2. Should we rate-limit unauthenticated requests?
3. Should we have different limits for different endpoints?

## Testing
- [x] Unit tests pass
- [x] Manual testing with 100+ requests
- [ ] Load testing (not done - need guidance on expected load)
```

---

## Escalation Criteria

### Escalate Immediately When:
- Confidence < 50%
- Security implications unclear
- Data loss risk
- Production outage risk
- Conflicting requirements
- Blocked by external dependency
- Estimated time > 2x original estimate

### Escalation Template

```
Subject: Need clarification on [task]

Current status: [In progress / Blocked / Completed but uncertain]
Confidence level: [X%]

Issue:
[Describe the uncertainty or blocker]

What I've tried:
1. [Attempt 1]
2. [Attempt 2]

Questions:
1. [Specific question 1]
2. [Specific question 2]

Impact if not resolved:
[What happens if we proceed with current approach]

Recommended next steps:
[Your suggestion for how to proceed]
```

---

## Confidence Calibration

### Track Your Accuracy

```
After each task, record:
- Initial confidence: 80%
- Outcome: Success / Partial success / Failure
- Actual difficulty: Easier / As expected / Harder

Over time, calibrate:
- If you're often wrong at 80%, you're overconfident
- If you're rarely wrong at 60%, you're underconfident
```

### Calibration Examples

```
Overconfident pattern:
- Confidence 90% → Failed 3 times
- Confidence 80% → Failed 2 times
- Adjustment: Lower confidence by 20%

Underconfident pattern:
- Confidence 60% → Succeeded 10 times
- Confidence 70% → Succeeded 8 times
- Adjustment: Raise confidence by 10%
```

---

## Checklist: Before Proceeding

- [ ] Confidence level assessed (0-100%)
- [ ] If < 70%, clarification questions prepared
- [ ] Assumptions documented
- [ ] Risks identified
- [ ] Verification criteria defined
- [ ] Escalation plan ready (if needed)

---

## Common Mistakes

### ❌ Overconfidence
```
"I'm 95% sure this is right"
[Proceeds without checking]
[Breaks production]
```

### ✅ Appropriate Confidence
```
"I'm 75% sure this is right"
[Documents assumptions]
[Asks for review]
[Catches issue before production]
```

---

### ❌ Underconfidence
```
"I'm only 50% sure" (for trivial task)
[Asks for help unnecessarily]
[Wastes reviewer's time]
```

### ✅ Appropriate Confidence
```
"I'm 95% sure" (for trivial task)
[Proceeds autonomously]
[Completes quickly]
```

---

### ❌ No Documentation of Uncertainty
```
[Implements with 60% confidence]
[Doesn't mention uncertainty]
[Reviewer assumes it's correct]
[Issue discovered in production]
```

### ✅ Documented Uncertainty
```
[Implements with 60% confidence]
[Documents assumptions in PR]
[Reviewer catches issue]
[Fixed before production]
```

---

## Further Reading

- [Dunning-Kruger Effect](https://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect)
- [Calibrated Probability Assessment](https://en.wikipedia.org/wiki/Calibrated_probability_assessment)
- [Asking Good Questions](https://stackoverflow.com/help/how-to-ask)
- [Escalation Best Practices](https://www.atlassian.com/incident-management/incident-response/escalation)

# @refactoring — Code Smells & Techniques

## Code Smells

### Duplicated Code

**Same code appears in multiple places.**

```python
# ❌ Duplication
def create_user(name, email):
    user = User()
    user.name = name
    user.email = email
    user.created_at = timezone.now()
    user.save()
    send_welcome_email(user)
    return user

def create_admin(name, email):
    user = User()
    user.name = name
    user.email = email
    user.created_at = timezone.now()
    user.is_admin = True
    user.save()
    send_welcome_email(user)
    return user

# ✅ Extract common logic
def create_user(name, email, is_admin=False):
    user = User(name=name, email=email, created_at=timezone.now(), is_admin=is_admin)
    user.save()
    send_welcome_email(user)
    return user
```

### Long Function

**Function does too many things.**

```python
# ❌ Long function (50+ lines)
def process_order(order_data):
    # Validate data (10 lines)
    # Calculate totals (15 lines)
    # Apply discounts (10 lines)
    # Create order (5 lines)
    # Send notifications (10 lines)
    # Update inventory (10 lines)

# ✅ Extract smaller functions
def process_order(order_data):
    validate_order_data(order_data)
    total = calculate_order_total(order_data)
    total = apply_discounts(total, order_data)
    order = create_order(order_data, total)
    send_order_notifications(order)
    update_inventory(order)
    return order
```

### Large Class (God Object)

```python
# ❌ God class (does everything)
class Article:
    def save(self): ...
    def send_email_notification(self): ...
    def index_in_search(self): ...
    def generate_pdf(self): ...
    def post_to_social_media(self): ...

# ✅ Single Responsibility Principle
class Article:
    def save(self): ...

class ArticleNotifier:
    def send_email(self, article): ...

class ArticleSearchIndexer:
    def index(self, article): ...
```

### Long Parameter List

```python
# ❌ Too many parameters
def create_article(title, content, author, category, tags,
                   published_date, featured, allow_comments,
                   seo_title, seo_description, og_image):
    pass

# ✅ Use object/dict
def create_article(article_data):
    pass
```

### Magic Numbers

```python
# ❌ Magic numbers
if user.age < 18:
    return "Too young"
if order.total > 1000:
    apply_discount(order, 0.1)

# ✅ Named constants
MINIMUM_AGE = 18
BULK_ORDER_THRESHOLD = 1000
BULK_ORDER_DISCOUNT = 0.1

if user.age < MINIMUM_AGE:
    return "Too young"
if order.total > BULK_ORDER_THRESHOLD:
    apply_discount(order, BULK_ORDER_DISCOUNT)
```

### Nested Conditionals

```python
# ❌ Deep nesting
def process_payment(user, amount):
    if user:
        if user.is_active:
            if user.has_payment_method:
                if amount > 0:
                    if amount <= user.balance:
                        return True

# ✅ Guard clauses (early return)
def process_payment(user, amount):
    if not user: return False
    if not user.is_active: return False
    if not user.has_payment_method: return False
    if amount <= 0: return False
    if amount > user.balance: return False
    return True
```

---

## Refactoring Techniques

### Extract Function

```python
# Before
def generate_report(data):
    total = 0
    for item in data:
        total += item['price'] * item['quantity']
    output = f"Total: ${total:.2f}\nItems: {len(data)}\n"
    return output

# After
def generate_report(data):
    total = calculate_total(data)
    return format_report_output(total, len(data))

def calculate_total(data):
    return sum(item['price'] * item['quantity'] for item in data)

def format_report_output(total, item_count):
    return f"Total: ${total:.2f}\nItems: {item_count}\n"
```

### Rename Variable/Function

```python
# Before
def calc(x, y):
    z = x * y * 0.1
    return z

# After
def calculate_discount(price, quantity):
    discount_rate = 0.1
    return price * quantity * discount_rate
```

### Extract Variable

```python
# Before
if (user.age >= 18 and user.country == 'US' and
    user.has_verified_email and not user.is_banned):
    allow_access()

# After
is_adult = user.age >= 18
is_us_user = user.country == 'US'
is_verified = user.has_verified_email
is_allowed = not user.is_banned

if is_adult and is_us_user and is_verified and is_allowed:
    allow_access()
```

---

## Further Reading

- [Refactoring: Improving the Design of Existing Code](https://martinfowler.com/books/refactoring.html) — Martin Fowler
- [Working Effectively with Legacy Code](https://www.oreilly.com/library/view/working-effectively-with/0131177052/) — Michael Feathers
- [Code Smells Catalog](https://refactoring.guru/refactoring/smells)
- [Refactoring Patterns](https://refactoring.guru/refactoring/techniques)

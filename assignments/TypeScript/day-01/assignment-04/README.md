# Assignment 4: Subscription & Streaming Service

## 🎬 Media Streaming Subscription System

### 📌 Objective

Build a TypeScript-based subscription management system using:

- Classes and Objects
- Access Modifiers
- Encapsulation
- Getters and Setters
- Mutators
- Inheritance
- Method Overriding
- `super` keyword
- Business Rule Validation
- Billing Calculations

You will create a base `BaseSubscription` class and extend it with a `PremiumSubscription` class.

---

# 📖 Problem Explanation

A media streaming service offers different subscription plans.

Each subscription contains:

- User account details
- Monthly subscription fee
- Streaming quality
- Maximum simultaneous streams
- User region
- Discount eligibility

A premium subscription provides additional benefits such as:

- More simultaneous streams
- 4K Ultra HD streaming
- Premium add-ons
- Customized billing

The system must protect sensitive subscription information and apply business rules when calculating the monthly bill.

---

# 1. Base Class: `BaseSubscription`

Create a class called:

```typescript
BaseSubscription
```

The class should contain:

```typescript
private _userName: string;
private _userRegion: string;
private _monthlyFee: number;
private _streamingQuality: "SD" | "HD";
private _maxStreams: number;
```

---

# 2. Constructor

Create a constructor:

```typescript
constructor(
  userName: string,
  userRegion: string,
  monthlyFee: number
)
```

The constructor should initialize:

- User name
- User region
- Monthly fee

Set the default streaming quality to:

```text
HD
```

Set the default maximum simultaneous streams to:

```text
2
```

Example:

```typescript
const subscription = new BaseSubscription(
  "Avinash",
  "IN",
  499
);
```

---

# 3. User Information Getters

Create a getter for the user name:

```typescript
public get userName(): string
```

Create a getter for the region:

```typescript
public get userRegion(): string
```

These properties should not be directly modified from outside the class.

Example:

```typescript
console.log(subscription.userName);
console.log(subscription.userRegion);
```

Expected:

```text
Avinash
IN
```

---

# 4. Monthly Fee

The monthly fee must be protected from direct modification.

Create:

```typescript
protected _monthlyFee: number;
```

or use:

```typescript
private _monthlyFee: number;
```

depending on your implementation approach.

The fee must be updated only through a dedicated mutator method.

---

# 5. Monthly Fee Mutator

Create a method:

```typescript
public updateMonthlyFee(
  newFee: number,
  discountEligible: boolean
): void
```

The method should update the monthly fee only when the business rules are satisfied.

### Business Rules

The fee must:

- Be greater than `0`
- Be eligible for the requested discount
- Apply a discount when the user is eligible

For example, if a user is eligible for a **10% discount**:

```text
Original Fee = ₹500
Discount     = 10%
Final Fee    = ₹450
```

If the user is not eligible:

```text
Original Fee = ₹500
Final Fee    = ₹500
```

---

# 6. Monthly Fee Getter

Create:

```typescript
public get monthlyFee(): number
```

Example:

```typescript
console.log(subscription.monthlyFee);
```

---

# 7. Streaming Quality

Create a getter:

```typescript
public get streamingQuality():
  "SD" | "HD"
```

and a setter:

```typescript
public set streamingQuality(
  quality: "SD" | "HD"
)
```

Only supported qualities should be accepted.

Valid values:

```text
SD
HD
```

---

# 8. Maximum Simultaneous Streams

Create:

```typescript
public get maxStreams(): number
```

The base subscription should allow:

```text
2 simultaneous streams
```

Example:

```typescript
console.log(subscription.maxStreams);
```

Expected:

```text
2
```

---

# 9. Base Billing Method

Create:

```typescript
public calculateBill(): number
```

For the base subscription, the monthly bill should simply return the current monthly fee.

Example:

```typescript
const subscription = new BaseSubscription(
  "Avinash",
  "IN",
  499
);

console.log(subscription.calculateBill());
```

Expected:

```text
499
```

---

# 10. Premium Subscription

Create a subclass:

```typescript
PremiumSubscription
```

It must extend:

```typescript
BaseSubscription
```

Example:

```typescript
export class PremiumSubscription
  extends BaseSubscription
```

The premium subscription should provide:

- More simultaneous streams
- 4K Ultra HD streaming
- Premium add-on
- Customized billing

---

# 11. Premium Constructor

Create:

```typescript
constructor(
  userName: string,
  userRegion: string,
  monthlyFee: number,
  addOnFee: number
)
```

Use:

```typescript
super(
  userName,
  userRegion,
  monthlyFee
);
```

to initialize the parent class.

---

# 12. Premium Streaming Features

The premium subscription should allow:

```text
Maximum Streams: 4
Streaming Quality: 4K
```

You can introduce the following type:

```typescript
type PremiumQuality = "HD" | "4K";
```

The premium subscription should override the streaming quality functionality if required.

---

# 13. 4K Ultra HD Add-On

Create a private property:

```typescript
private _addOnFee: number;
```

This represents the additional monthly charge for 4K Ultra HD streaming.

Example:

```text
Base Subscription = ₹699
4K Add-on         = ₹150

Total             = ₹849
```

---

# 14. Add-On Fee Getter

Create:

```typescript
public get addOnFee(): number
```

Example:

```typescript
console.log(subscription.addOnFee);
```

---

# 15. Override `calculateBill()`

The premium subscription must override:

```typescript
public override calculateBill(): number
```

The method must first call the parent's billing method:

```typescript
super.calculateBill()
```

Then add the premium add-on fee.

Example:

```typescript
return super.calculateBill() + this._addOnFee;
```

---

# 🧑‍💻 Boilerplate Code

Use the following starter code.

```typescript
// ==========================================
// 1. Base Subscription
// ==========================================

export class BaseSubscription {
  private _userName: string;
  private _userRegion: string;

  protected _monthlyFee: number;

  private _streamingQuality: "SD" | "HD" = "HD";
  private _maxStreams: number = 2;

  constructor(
    userName: string,
    userRegion: string,
    monthlyFee: number
  ) {
    this._userName = userName;
    this._userRegion = userRegion;
    this._monthlyFee = monthlyFee;
  }

  public get userName(): string {
    return this._userName;
  }

  public get userRegion(): string {
    return this._userRegion;
  }

  public get monthlyFee(): number {
    return this._monthlyFee;
  }

  // Dedicated mutator for monthly fee
  public updateMonthlyFee(
    newFee: number,
    discountEligible: boolean
  ): void {

    // TODO:
    // Ensure newFee is greater than 0.

    // TODO:
    // If discountEligible is true,
    // apply a 10% discount.

    // TODO:
    // Otherwise use the original fee.
  }

  public get streamingQuality():
    "SD" | "HD" {
    return this._streamingQuality;
  }

  public set streamingQuality(
    quality: "SD" | "HD"
  ) {
    // TODO:
    // Update streaming quality.
  }

  public get maxStreams(): number {
    return this._maxStreams;
  }

  public calculateBill(): number {
    // TODO:
    // Return monthly fee.
    return 0;
  }
}


// ==========================================
// 2. Premium Subscription
// ==========================================

export class PremiumSubscription
  extends BaseSubscription {

  private _addOnFee: number;

  private _premiumQuality: "HD" | "4K" = "4K";

  constructor(
    userName: string,
    userRegion: string,
    monthlyFee: number,
    addOnFee: number
  ) {

    // TODO:
    // Call parent constructor using super()

    this._addOnFee = addOnFee;
  }

  public get addOnFee(): number {
    return this._addOnFee;
  }

  public get premiumQuality():
    "HD" | "4K" {
    return this._premiumQuality;
  }

  public override calculateBill(): number {

    // TODO:
    // Call parent calculateBill()
    // using super.calculateBill()

    // TODO:
    // Add the premium add-on fee.

    return 0;
  }
}
```

---

# 🧪 Test Cases

## Test Case 1 – Basic Subscription

```typescript
const subscription = new BaseSubscription(
  "Avinash",
  "IN",
  499
);

console.log(subscription.userName);
console.log(subscription.userRegion);
console.log(subscription.monthlyFee);
console.log(subscription.streamingQuality);
console.log(subscription.maxStreams);
console.log(subscription.calculateBill());
```

Expected:

```text
Avinash
IN
499
HD
2
499
```

---

# Test Case 2 – Update Monthly Fee

```typescript
const subscription = new BaseSubscription(
  "Rahul",
  "IN",
  499
);

subscription.updateMonthlyFee(
  599,
  false
);

console.log(subscription.monthlyFee);
```

Expected:

```text
599
```

---

# Test Case 3 – Discount Eligible User

```typescript
const subscription = new BaseSubscription(
  "Priya",
  "IN",
  500
);

subscription.updateMonthlyFee(
  500,
  true
);

console.log(subscription.monthlyFee);
```

Expected:

```text
450
```

Calculation:

```text
Original Fee = ₹500
Discount     = 10%
Discount     = ₹50

Final Fee    = ₹450
```

---

# Test Case 4 – Change Streaming Quality

```typescript
const subscription = new BaseSubscription(
  "Kiran",
  "IN",
  499
);

subscription.streamingQuality = "SD";

console.log(subscription.streamingQuality);
```

Expected:

```text
SD
```

---

# Test Case 5 – Premium Subscription

```typescript
const subscription =
  new PremiumSubscription(
    "Avinash",
    "IN",
    699,
    150
  );

console.log(subscription.userName);
console.log(subscription.userRegion);
console.log(subscription.monthlyFee);
console.log(subscription.premiumQuality);
console.log(subscription.addOnFee);
console.log(subscription.calculateBill());
```

Expected:

```text
Avinash
IN
699
4K
150
849
```

Calculation:

```text
Base Fee  = ₹699
4K Add-on = ₹150
----------------
Total     = ₹849
```

---

# Test Case 6 – Premium Billing

```typescript
const premium =
  new PremiumSubscription(
    "Rahul",
    "IN",
    799,
    200
  );

console.log(
  premium.calculateBill()
);
```

Expected:

```text
999
```

The calculation should internally work like:

```text
super.calculateBill()
        ↓
      ₹799
        +
  Premium Add-on
      ₹200
        ↓
      ₹999
```

---

# Test Case 7 – Premium Discount

```typescript
const premium =
  new PremiumSubscription(
    "Priya",
    "IN",
    1000,
    200
  );

premium.updateMonthlyFee(
  1000,
  true
);

console.log(
  premium.calculateBill()
);
```

Expected:

```text
1100
```

Calculation:

```text
Base Fee       = ₹1000
10% Discount   = ₹100
Discounted Fee = ₹900

4K Add-on      = ₹200
---------------------
Final Bill     = ₹1100
```

---

# ❌ Validation Test Case

Test an invalid monthly fee:

```typescript
const subscription =
  new BaseSubscription(
    "Test User",
    "IN",
    499
  );

subscription.updateMonthlyFee(
  -100,
  false
);
```

The implementation should prevent the invalid value.

You may either:

```typescript
throw new Error(
  "Monthly fee must be greater than 0"
);
```

or safely ignore the invalid update.

---

# 🌍 Region-Based Discount

To make the assignment more realistic, you can optionally introduce a region-based discount rule.

For example:

```text
Region: IN
Discount: 10%

Other regions:
No automatic regional discount
```

The method can consider both:

```text
User Region
+
Discount Eligibility
```

before updating `_monthlyFee`.

Example:

```typescript
if (
  this._userRegion === "IN" &&
  discountEligible
) {
  this._monthlyFee = newFee * 0.90;
}
```

This demonstrates how a real application might implement business rules.

---

# 🎯 Concepts You Must Demonstrate

| Concept | Requirement |
|---|---|
| Class | `BaseSubscription` |
| Inheritance | `PremiumSubscription extends BaseSubscription` |
| Encapsulation | Private/protected properties |
| Getter | User information |
| Getter/Setter | Streaming quality |
| Mutator | `updateMonthlyFee()` |
| Validation | Monthly fee |
| Business Rules | Discount eligibility |
| Constructor | Subscription initialization |
| `super()` | Parent constructor |
| `super.calculateBill()` | Parent billing |
| Method Overriding | `calculateBill()` |
| Add-on Calculation | 4K Ultra HD |
| Access Modifiers | `private`, `protected`, `public` |
| TypeScript | Strong typing |

---

# 📁 Suggested File Structure

```text
day-01/
│
├── assignment-01/
│   ├── README.md
│   └── solution.ts
│
├── assignment-02/
│   ├── README.md
│   └── solution.ts
│
├── assignment-03/
│   ├── README.md
│   └── solution.ts
│
└── assignment-04/
    ├── README.md
    └── solution.ts
```

---

# 📤 Submission Instructions

1. Create an `assignment-04` folder.
2. Create `README.md`.
3. Create `solution.ts`.
4. Copy the boilerplate code into `solution.ts`.
5. Complete all `TODO` sections.
6. Implement the required business rules.
7. Test all valid and invalid inputs.
8. Verify the billing calculations.
9. Commit your changes.
10. Push the code to your GitHub repository.

Example:

```bash
git add .
git commit -m "Complete Assignment 4 - Subscription Streaming Service"
git push
```

---

# ✅ Submission Checklist

Before submitting, verify:

- [ ] `BaseSubscription` is implemented.
- [ ] `PremiumSubscription` extends `BaseSubscription`.
- [ ] User information is protected using access modifiers.
- [ ] Monthly fee is protected/private.
- [ ] Monthly fee is updated through a dedicated mutator.
- [ ] Discount eligibility is checked.
- [ ] Invalid fees are handled.
- [ ] Streaming quality getter/setter works.
- [ ] Maximum stream count is available.
- [ ] `calculateBill()` works for base subscription.
- [ ] `super()` is used in the premium constructor.
- [ ] Premium add-on fee is implemented.
- [ ] `calculateBill()` is overridden.
- [ ] `super.calculateBill()` is called.
- [ ] Add-on cost is included in the final bill.
- [ ] All test cases are working.
- [ ] Code is committed and pushed to GitHub.

---

# ⭐ Learning Outcome

After completing this assignment, you should understand how inheritance can be used to extend a common subscription system.

```text
BaseSubscription
│
├── userName
├── userRegion
├── monthlyFee
├── streamingQuality
├── maxStreams
│
├── updateMonthlyFee()
└── calculateBill()
          │
          ▼
PremiumSubscription
│
├── 4K Quality
├── Add-on Fee
│
└── calculateBill()
       │
       ├── super.calculateBill()
       │
       └── + Add-on Fee
```

### 🔑 Key Takeaway

The child class should **reuse the parent's billing logic** instead of duplicating it.

```typescript
public override calculateBill(): number {
  return super.calculateBill() + this._addOnFee;
}
```

This demonstrates one of the most important benefits of **inheritance and method overriding in TypeScript**.
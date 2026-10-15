# Assignment 3: Payment Processing – Abstraction

## Objective

Build a payment processing system using **Abstraction**.

The application should define common payment behavior without exposing payment-specific implementation details.

## Concepts Covered

- `abstract class`
- `abstract method`
- Concrete implementation
- `extends`
- `super`
- Polymorphism
- Abstraction

## Business Scenario

An e-commerce application supports:

- UPI
- Credit Card
- Net Banking

Every payment has common behavior:

```text
pay()
generateReceipt()
```

But the actual payment process is different for each payment type.

## Requirements

Create an abstract class:

```ts
abstract class Payment
```

It must contain:

```text
abstract processPayment(amount: number): void
generateReceipt(amount: number): void
```

Create three child classes:

```text
UpiPayment
CreditCardPayment
NetBankingPayment
```

Each child class must implement:

```text
processPayment(amount: number): void
```

## Business Rules

### UPI

Display:

```text
Processing UPI payment of ₹5000
UPI payment successful
```

### Credit Card

Display:

```text
Processing Credit Card payment of ₹5000
Credit Card payment successful
```

### Net Banking

Display:

```text
Processing Net Banking payment of ₹5000
Net Banking payment successful
```

After successful payment, generate a receipt.

## Polymorphism Requirement

Use:

```ts
const payments: Payment[] = [
    new UpiPayment(),
    new CreditCardPayment(),
    new NetBankingPayment()
];
```

Then process all payments using the common parent type.

## Folder Structure

```text
assignment-03/
├── README.md
└── starter/
    ├── Payment.ts
    ├── UpiPayment.ts
    ├── CreditCardPayment.ts
    ├── NetBankingPayment.ts
    └── main.ts
```

## How to Run

```bash
tsc starter/*.ts
node starter/main.js
```

## Important

Do not implement payment-specific logic inside the abstract `Payment` class.

The purpose is to hide implementation details and force child classes to provide their own payment behavior.

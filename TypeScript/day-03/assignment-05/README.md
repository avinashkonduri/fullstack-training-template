# Assignment 5: E-Commerce Order & Payment System

## Objective

Build a simplified **E-Commerce Order & Payment System** using:

- Encapsulation
- Abstraction
- Interfaces
- Inheritance
- Polymorphism

This is the final application-level assignment for these concepts.

## Business Scenario

An e-commerce application creates customer orders and accepts different payment methods.

The system should protect order information, define common payment behavior, and allow different payment implementations.

## Part 1 – Encapsulation

Create:

```text
Order
```

### Properties

```text
orderId
customerName
totalAmount
status
```

Rules:

- `orderId` must be `public readonly`.
- `customerName` can be public.
- `totalAmount` must be private.
- `status` must be private.
- The amount cannot be directly changed from outside.
- The status can only be changed using a public method.

Required methods:

```text
getTotalAmount(): number
addAmount(amount: number): void
confirmOrder(): void
cancelOrder(): void
getStatus(): string
```

## Part 2 – Abstraction

Create:

```text
abstract class Payment
```

It must define:

```text
abstract pay(amount: number): void
generateReceipt(amount: number): void
```

## Part 3 – Interface

Create:

```text
interface PaymentMethod
```

It must define:

```text
pay(amount: number): void
refund(transactionId: string): void
```

## Part 4 – Payment Implementations

Create:

```text
UpiPayment
CreditCardPayment
```

Both classes must:

- Extend `Payment`
- Implement `PaymentMethod`
- Implement `pay()`
- Implement `refund()`

## Part 5 – Polymorphism

Use:

```ts
const paymentMethods: Payment[] = [
    new UpiPayment(),
    new CreditCardPayment()
];
```

Process the same order amount through both payment objects.

## Expected Flow

```text
Order Created
      ↓
Order Amount Calculated
      ↓
Order Confirmed
      ↓
Payment Selected
      ↓
UPI / Credit Card
      ↓
Payment Successful
      ↓
Receipt Generated
```

## Expected Example

```text
Order ID: ORD1001
Customer: Rahul
Order Amount: ₹15000
Order Status: CONFIRMED

Paid ₹15000 using UPI
Payment receipt generated

Refund initiated for TXN1001
```

## Folder Structure

```text
assignment-05/
├── README.md
└── starter/
    ├── Order.ts
    ├── Payment.ts
    ├── PaymentMethod.ts
    ├── UpiPayment.ts
    ├── CreditCardPayment.ts
    └── main.ts
```

## How to Run

```bash
tsc starter/*.ts
node starter/main.js
```

## Restrictions

Do not:

- Make `totalAmount` public.
- Make `status` public.
- Remove the abstract `Payment` class.
- Remove the `PaymentMethod` interface.
- Put all payment logic into one class.

## Learning Goal

Your implementation should demonstrate:

```text
Encapsulation
    ↓
Protect Order Data

Abstraction
    ↓
Define Common Payment Behavior

Interface
    ↓
Define Payment Contract

Inheritance
    ↓
Reuse Payment Behavior

Polymorphism
    ↓
Same Payment API → Different Payment Behavior
```

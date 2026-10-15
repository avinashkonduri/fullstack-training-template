# Assignment 1: Bank Account – Encapsulation

## Objective

Build a simple bank account system using **Encapsulation**.

You will protect account data using `private` properties and expose controlled operations through `public` methods.

## Concepts Covered

- `private` properties
- `public` methods
- Encapsulation
- Constructor
- Validation
- Controlled access to data
- Getter-style methods

## Business Requirements

Create a `BankAccount` class.

The account must contain:

- `accountNumber`
- `accountHolderName`
- `balance`

### Rules

1. `accountNumber` must not be directly accessible outside the class.
2. `balance` must not be directly accessible outside the class.
3. The balance can only be changed through `deposit()` and `withdraw()`.
4. Deposit amount must be greater than `0`.
5. Withdrawal amount must be greater than `0`.
6. Withdrawal must not exceed the available balance.
7. Provide a method to read the current balance.
8. Provide a method to display account details.

## Required Methods

```text
deposit(amount: number): void
withdraw(amount: number): void
getBalance(): number
displayAccountDetails(): void
```

## Expected Example

```text
Account Holder: Rahul
Account Number: SB1001
Initial Balance: ₹10000

Deposited: ₹5000
Withdrawn: ₹2000

Current Balance: ₹13000
```

## Important

Do not make `balance` public.

This is an **Encapsulation** assignment, so the internal data must be protected.

## Folder Structure

```text
assignment-01/
├── README.md
└── starter/
    └── bank-account.ts
```

## How to Run

```bash
tsc starter/bank-account.ts
node starter/bank-account.js
```

## Submission

Implement all TODO sections in the starter file.

Do not change the class name or required method names.

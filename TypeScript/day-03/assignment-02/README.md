# Assignment 2: Employee Payroll – Encapsulation

## Objective

Build an employee payroll component using **Encapsulation**.

Salary information is sensitive business data. It should not be directly modified from outside the class.

## Concepts Covered

- `private`
- `public`
- Encapsulation
- Getter method
- Controlled update
- Validation
- Business rules

## Business Scenario

A company maintains employee payroll information.

Each employee has:

- Employee ID
- Employee name
- Basic salary
- Bonus
- Active status

The salary values must be protected.

## Requirements

Create an `Employee` class.

### Properties

```text
employeeId
employeeName
basicSalary
bonus
isActive
```

### Rules

1. `employeeId` and salary-related properties must be private.
2. `employeeName` may be public.
3. Basic salary must be greater than `0`.
4. Bonus cannot be negative.
5. Salary must be updated only through a method.
6. Provide a method to calculate total salary.
7. Provide a method to update the bonus.
8. Provide a method to display employee details.

## Required Methods

```text
getBasicSalary(): number
getBonus(): number
updateBasicSalary(newSalary: number): void
updateBonus(newBonus: number): void
calculateTotalSalary(): number
displayEmployeeDetails(): void
```

## Expected Example

```text
Employee: Priya
Employee ID: EMP101

Basic Salary: ₹50000
Bonus: ₹5000
Total Salary: ₹55000

Updated Bonus: ₹8000
New Total Salary: ₹58000
```

## Business Rule

This should NOT be allowed:

```ts
employee.basicSalary = 100000;
```

The salary must be changed through:

```ts
employee.updateBasicSalary(100000);
```

## Folder Structure

```text
assignment-02/
├── README.md
└── starter/
    └── employee-payroll.ts
```

## How to Run

```bash
tsc starter/employee-payroll.ts
node starter/employee-payroll.js
```

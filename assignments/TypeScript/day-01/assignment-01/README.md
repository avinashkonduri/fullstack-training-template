# TypeScript Assignment 1 – Vehicle Rental System

## Objective

Build a simple Vehicle Rental System using TypeScript.

This assignment will help you practice:

- Classes
- Access Modifiers
- Private Properties
- Getters and Setters
- Encapsulation
- Inheritance
- `super()`
- Method Overriding
- `super.method()`
- Basic validation

---

## Problem Statement

In a vehicle rental platform, every vehicle has common information such as:

- Vehicle Identification Number (VIN)
- Daily rental rate
- Rental availability status

A `Car` is a specific type of `Vehicle`. In addition to the common vehicle properties, a car has:

- Passenger capacity
- Insurance fee

You need to complete the provided TypeScript boilerplate.

---

# Requirements

## 1. Vehicle Class

The `Vehicle` class contains:

```text
vin
dailyRate
isRented
```

### VIN

VIN should:

- Be stored as a private property.
- Be readable using a getter.
- Not be directly modifiable from outside the class.

Example:

```typescript
const vehicle = new Vehicle("VIN123", 50);

console.log(vehicle.vin);
```

Expected:

```text
VIN123
```

The following should NOT be allowed:

```typescript
vehicle.vin = "VIN456";
```

---

## 2. Daily Rental Rate

The daily rental rate should be controlled using a getter and setter.

The rental rate must always be greater than `0`.

Valid:

```typescript
vehicle.dailyRate = 50;
vehicle.dailyRate = 100;
```

Invalid:

```typescript
vehicle.dailyRate = 0;
vehicle.dailyRate = -20;
```

When an invalid rate is provided, throw an appropriate error.

---

## 3. Vehicle Rental Status

Initially:

```text
isRented = false
```

When:

```typescript
vehicle.rentVehicle();
```

is called, the vehicle should become rented.

The method should not incorrectly change the state if the vehicle is already rented.

---

## 4. Calculate Rental Cost

Implement:

```typescript
calculateRentalCost(days: number): number
```

The base rental cost is:

```text
daily rate × number of days
```

Example:

```text
Daily Rate = $50
Days = 3

Rental Cost = $150
```

---

# 5. Car Class

Create the `Car` class by extending `Vehicle`.

```typescript
class Car extends Vehicle
```

The car should have an additional property:

```text
passengerCapacity
```

Example:

```typescript
const car = new Car("CAR001", 50, 5);

console.log(car.passengerCapacity);
```

Expected:

```text
5
```

---

# 6. Using `super()`

The `Car` constructor must call the parent constructor using:

```typescript
super(...)
```

Pass the following values to the parent:

```text
vin
dailyRate
```

Then initialize:

```text
passengerCapacity
```

---

# 7. Override Rental Cost

The `Car` class must override:

```typescript
calculateRentalCost()
```

A car has an additional insurance fee of:

```text
$15 per day
```

Therefore:

```text
Car Rental Cost =
Base Rental Cost + Insurance Cost
```

Where:

```text
Base Rental Cost = dailyRate × days

Insurance Cost = 15 × days
```

Example:

```text
Daily Rate = $50
Days = 3

Base Cost = $150
Insurance = $45

Total = $195
```

The implementation must use:

```typescript
super.calculateRentalCost(days)
```

instead of duplicating the base calculation.

---

# Expected Concepts

Your solution should demonstrate:

- `private`
- `public`
- `get`
- `set`
- `extends`
- `super()`
- `override`
- Method overriding
- Encapsulation

---

# Submission Instructions

Do NOT modify the files inside:

```text
starter/
```

Copy the starter code into:

```text
submission/
```

Your final structure should be:

```text
day-01/
├── README.md
├── starter/
│   └── vehicle-rental.ts
│
└── submission/
    └── vehicle-rental.ts
```

Complete your solution only inside:

```text
submission/vehicle-rental.ts
```

---

# Testing Requirements

Before submitting, test the following:

### Test 1 – Vehicle Creation

```typescript
const vehicle = new Vehicle("VIN001", 50);

console.log(vehicle.vin);
console.log(vehicle.dailyRate);
console.log(vehicle.isRented);
```

Expected:

```text
VIN001
50
false
```

---

### Test 2 – Rent Vehicle

```typescript
vehicle.rentVehicle();

console.log(vehicle.isRented);
```

Expected:

```text
true
```

---

### Test 3 – Rental Cost

```typescript
console.log(vehicle.calculateRentalCost(3));
```

Expected:

```text
150
```

---

### Test 4 – Car

```typescript
const car = new Car("CAR001", 50, 5);

console.log(car.vin);
console.log(car.dailyRate);
console.log(car.passengerCapacity);
```

Expected:

```text
CAR001
50
5
```

---

### Test 5 – Car Rental Cost

```typescript
console.log(car.calculateRentalCost(3));
```

Expected:

```text
195
```

Because:

```text
Base Cost = 50 × 3 = 150
Insurance = 15 × 3 = 45

Total = 195
```

---

### Test 6 – Invalid Rental Rate

Try:

```typescript
vehicle.dailyRate = 0;
```

and:

```typescript
vehicle.dailyRate = -10;
```

Both should be rejected.

---

# Submission Checklist

Before pushing your code, verify:

- [ ] VIN is private
- [ ] VIN can be read using a getter
- [ ] VIN cannot be modified externally
- [ ] Daily rate is private
- [ ] Daily rate uses getter/setter
- [ ] Daily rate cannot be `0` or negative
- [ ] `isRented` initially starts as `false`
- [ ] `rentVehicle()` changes the rental state
- [ ] Base rental calculation works
- [ ] `Car` extends `Vehicle`
- [ ] `Car` uses `super()`
- [ ] Passenger capacity works
- [ ] `calculateRentalCost()` is overridden
- [ ] `super.calculateRentalCost()` is used
- [ ] $15/day insurance is included
- [ ] Code compiles without TypeScript errors

---

## Git Submission

From your repository:

```bash
git status
```

Then:

```bash
git add .
```

Commit:

```bash
git commit -m "Completed TypeScript Day 01 Assignment"
```

Push:

```bash
git push
```

Your assignment is considered submitted after the code is pushed to GitHub.

**Do not send the solution through WhatsApp, email, or chat.**

Only the code pushed to your assigned GitHub repository will be evaluated.
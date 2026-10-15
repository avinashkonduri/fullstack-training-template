// typescript
import { Vehicle, Car } from "../../../../TypeScript/02/01/solution";

// ==========================================
// TypeScript Assignment 1
// Vehicle Rental System
// Hidden Trainer Tests
// ==========================================

describe("Vehicle Rental System - Vehicle", () => {

  // ------------------------------------------
  // Constructor
  // ------------------------------------------

  test("should create a vehicle with VIN and daily rate", () => {
    const vehicle = new Vehicle("VIN001", 50);

    expect(vehicle.vin).toBe("VIN001");
    expect(vehicle.dailyRate).toBe(50);
    expect(vehicle.isRented).toBe(false);
  });


  // ------------------------------------------
  // VIN
  // ------------------------------------------

  test("VIN should be read-only through getter", () => {
    const vehicle = new Vehicle("VIN002", 75);

    expect(vehicle.vin).toBe("VIN002");
  });


  // ------------------------------------------
  // Daily Rate
  // ------------------------------------------

  test("should update daily rate when rate is greater than zero", () => {
    const vehicle = new Vehicle("VIN003", 50);

    vehicle.dailyRate = 80;

    expect(vehicle.dailyRate).toBe(80);
  });


  test("should not allow daily rate of zero", () => {
    const vehicle = new Vehicle("VIN004", 50);

    vehicle.dailyRate = 0;

    expect(vehicle.dailyRate).toBe(50);
  });


  test("should not allow negative daily rate", () => {
    const vehicle = new Vehicle("VIN005", 50);

    vehicle.dailyRate = -20;

    expect(vehicle.dailyRate).toBe(50);
  });


  // ------------------------------------------
  // Rental Status
  // ------------------------------------------

  test("vehicle should initially not be rented", () => {
    const vehicle = new Vehicle("VIN006", 60);

    expect(vehicle.isRented).toBe(false);
  });


  test("rentVehicle should mark vehicle as rented", () => {
    const vehicle = new Vehicle("VIN007", 60);

    vehicle.rentVehicle();

    expect(vehicle.isRented).toBe(true);
  });


  test("rentVehicle should keep vehicle rented when called again", () => {
    const vehicle = new Vehicle("VIN008", 60);

    vehicle.rentVehicle();
    vehicle.rentVehicle();

    expect(vehicle.isRented).toBe(true);
  });


  // ------------------------------------------
  // Rental Cost
  // ------------------------------------------

  test("should calculate rental cost correctly", () => {
    const vehicle = new Vehicle("VIN009", 50);

    expect(vehicle.calculateRentalCost(1)).toBe(50);
    expect(vehicle.calculateRentalCost(3)).toBe(150);
    expect(vehicle.calculateRentalCost(7)).toBe(350);
  });


  test("should return zero rental cost for zero days", () => {
    const vehicle = new Vehicle("VIN010", 50);

    expect(vehicle.calculateRentalCost(0)).toBe(0);
  });

});


// ==========================================
// Car Tests
// ==========================================

describe("Vehicle Rental System - Car", () => {

  // ------------------------------------------
  // Constructor / Inheritance
  // ------------------------------------------

  test("should create a Car using Vehicle properties", () => {
    const car = new Car("CAR001", 100, 5);

    expect(car.vin).toBe("CAR001");
    expect(car.dailyRate).toBe(100);
    expect(car.isRented).toBe(false);
  });


  test("Car should store passenger capacity", () => {
    const car = new Car("CAR002", 120, 7);

    expect(car.passengerCapacity).toBe(7);
  });


  test("Car should inherit rentVehicle behavior", () => {
    const car = new Car("CAR003", 100, 5);

    expect(car.isRented).toBe(false);

    car.rentVehicle();

    expect(car.isRented).toBe(true);
  });


  // ------------------------------------------
  // Method Override
  // ------------------------------------------

  test("Car rental cost should include $15 insurance per day", () => {
    const car = new Car("CAR004", 100, 5);

    expect(car.calculateRentalCost(1)).toBe(115);
    expect(car.calculateRentalCost(2)).toBe(230);
    expect(car.calculateRentalCost(5)).toBe(575);
  });


  test("Car should use the Vehicle base rental calculation", () => {
    const car = new Car("CAR005", 80, 4);

    // Base cost = 80 * 3 = 240
    // Insurance = 15 * 3 = 45
    // Final = 285

    expect(car.calculateRentalCost(3)).toBe(285);
  });


  test("Car rental cost should be zero for zero days", () => {
    const car = new Car("CAR006", 100, 5);

    expect(car.calculateRentalCost(0)).toBe(0);
  });


  // ------------------------------------------
  // Daily Rate Setter inherited by Car
  // ------------------------------------------

  test("Car should support inherited dailyRate setter", () => {
    const car = new Car("CAR007", 100, 5);

    car.dailyRate = 150;

    expect(car.dailyRate).toBe(150);
    expect(car.calculateRentalCost(2)).toBe(330);
  });


  test("Car should reject invalid daily rate", () => {
    const car = new Car("CAR008", 100, 5);

    car.dailyRate = 0;

    expect(car.dailyRate).toBe(100);

    car.dailyRate = -50;

    expect(car.dailyRate).toBe(100);
  });

});

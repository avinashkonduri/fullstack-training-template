// ==========================================
// TypeScript Assignment 1
// Vehicle Rental System
// ==========================================


// ==========================================
// 1. Base Class: Vehicle
// ==========================================

export class Vehicle {
  private _vin: string;
  private _dailyRate: number;
  private _isRented: boolean = false;

  constructor(vin: string, dailyRate: number) {
    this._vin = vin;
    this._dailyRate = dailyRate;
  }

  // Getter for VIN (read-only from outside)
  public get vin(): string {
    return this._vin;
  }

  // Getter for daily rate
  public get dailyRate(): number {
    return this._dailyRate;
  }

  // Setter for daily rate with validation
  public set dailyRate(rate: number) {
    // TODO:
    // Prevent setting a daily rate less than or equal to 0
  }

  // Getter for rental status
  public get isRented(): boolean {
    return this._isRented;
  }

  // Rent the vehicle
  public rentVehicle(): void {
    // TODO:
    // Set _isRented to true if the vehicle is not already rented
  }

  // Calculate base rental cost
  public calculateRentalCost(days: number): number {
    // TODO:
    // Return dailyRate * days

    return 0;
  }
}


// ==========================================
// 2. Subclass: Car
// ==========================================

export class Car extends Vehicle {
  private _passengerCapacity: number;

  constructor(
    vin: string,
    dailyRate: number,
    passengerCapacity: number
  ) {
    // TODO:
    // Call the parent constructor using super()

    this._passengerCapacity = passengerCapacity;
  }

  // Getter for passenger capacity
  public get passengerCapacity(): number {
    return this._passengerCapacity;
  }

  // Override rental cost
  public override calculateRentalCost(days: number): number {
    // TODO:
    // Use super.calculateRentalCost(days)
    // Add insurance cost of $15 per day

    return 0;
  }
}
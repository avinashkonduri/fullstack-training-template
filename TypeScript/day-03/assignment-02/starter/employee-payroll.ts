// Assignment 2: Employee Payroll - Encapsulation
// Do not change the class name or required method names.

export class Employee {

    public employeeName: string;

    // TODO: Keep employeeId private
    private employeeId: string;

    // TODO: Keep salary information private
    private basicSalary: number;
    private bonus: number;

    // TODO: Keep employee status private
    private isActive: boolean;

    constructor(
        employeeId: string,
        employeeName: string,
        basicSalary: number,
        bonus: number,
        isActive: boolean
    ) {
        this.employeeId = employeeId;
        this.employeeName = employeeName;
        this.basicSalary = basicSalary;
        this.bonus = bonus;
        this.isActive = isActive;
    }

    public getBasicSalary(): number {
        // TODO
        return 0;
    }

    public getBonus(): number {
        // TODO
        return 0;
    }

    public updateBasicSalary(newSalary: number): void {
        // TODO:
        // Validate newSalary and update basicSalary
    }

    public updateBonus(newBonus: number): void {
        // TODO:
        // Validate bonus and update bonus
    }

    public calculateTotalSalary(): number {
        // TODO
        return 0;
    }

    public displayEmployeeDetails(): void {
        // TODO: Display employee information
    }
}


// Test your implementation.

const employee = new Employee(
    "EMP101",
    "Priya",
    50000,
    5000,
    true
);

// TODO: Display employee details

// TODO: Print total salary

// TODO: Update bonus

// TODO: Print total salary again

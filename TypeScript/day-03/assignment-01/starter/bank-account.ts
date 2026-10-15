// Assignment 1: Bank Account - Encapsulation
// Do not change the class name or required method names.

export class BankAccount {

    // TODO: Make accountNumber private
    private accountNumber: string;

    // TODO: Make accountHolderName private
    private accountHolderName: string;

    // TODO: Keep balance private
    private balance: number;

    constructor(
        accountNumber: string,
        accountHolderName: string,
        initialBalance: number
    ) {
        // TODO: Initialize all properties

        this.accountNumber = accountNumber;
        this.accountHolderName = accountHolderName;
        this.balance = initialBalance;
    }

    public deposit(amount: number): void {
        // TODO:
        // 1. Validate that amount is greater than 0
        // 2. Add amount to balance
        // 3. Display a suitable message
    }

    public withdraw(amount: number): void {
        // TODO:
        // 1. Validate that amount is greater than 0
        // 2. Check whether sufficient balance is available
        // 3. Deduct amount from balance
        // 4. Display a suitable message
    }

    public getBalance(): number {
        // TODO: Return the current balance
        return 0;
    }

    public displayAccountDetails(): void {
        // TODO: Display account holder, account number and balance
    }
}


// Test your implementation here.

const account = new BankAccount(
    "SB1001",
    "Rahul",
    10000
);

// TODO: Call deposit()

// TODO: Call withdraw()

// TODO: Display account details

// TODO: Print the current balance

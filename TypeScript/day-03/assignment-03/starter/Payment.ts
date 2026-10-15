// Assignment 3: Payment Processing - Abstraction

export abstract class Payment {

    // TODO: Define an abstract method.
    // processPayment(amount: number): void

    public generateReceipt(amount: number): void {
        // TODO: Display a payment receipt message.
        console.log(`Receipt generated for ₹${amount}`);
    }
}

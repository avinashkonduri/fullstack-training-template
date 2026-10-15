import { Payment } from "./Payment";

export class CreditCardPayment extends Payment {

    public processPayment(amount: number): void {
        // TODO:
        // Implement Credit Card-specific payment logic.
        // Call generateReceipt() after successful payment.
    }
}

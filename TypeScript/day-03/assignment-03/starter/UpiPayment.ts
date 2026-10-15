import { Payment } from "./Payment";

export class UpiPayment extends Payment {

    public processPayment(amount: number): void {
        // TODO:
        // Implement UPI-specific payment logic.
        // Call generateReceipt() after successful payment.
    }
}

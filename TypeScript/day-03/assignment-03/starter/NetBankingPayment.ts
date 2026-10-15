import { Payment } from "./Payment";

export class NetBankingPayment extends Payment {

    public processPayment(amount: number): void {
        // TODO:
        // Implement Net Banking-specific payment logic.
        // Call generateReceipt() after successful payment.
    }
}

import { Payment } from "./Payment";
import { PaymentMethod } from "./PaymentMethod";

export class UpiPayment extends Payment implements PaymentMethod {

    public pay(amount: number): void {
        // TODO:
        // Implement UPI payment.
        // Generate receipt after successful payment.
    }

    public refund(transactionId: string): void {
        // TODO:
        // Implement UPI refund.
    }
}

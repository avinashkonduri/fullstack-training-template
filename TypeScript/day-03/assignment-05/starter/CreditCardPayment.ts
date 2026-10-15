import { Payment } from "./Payment";
import { PaymentMethod } from "./PaymentMethod";

export class CreditCardPayment extends Payment implements PaymentMethod {

    public pay(amount: number): void {
        // TODO:
        // Implement Credit Card payment.
        // Generate receipt after successful payment.
    }

    public refund(transactionId: string): void {
        // TODO:
        // Implement Credit Card refund.
    }
}

import { Payment } from "./Payment";
import { UpiPayment } from "./UpiPayment";
import { CreditCardPayment } from "./CreditCardPayment";
import { NetBankingPayment } from "./NetBankingPayment";

const payments: Payment[] = [
    new UpiPayment(),
    new CreditCardPayment(),
    new NetBankingPayment()
];

const amount = 5000;

// TODO:
// Loop through payments and call processPayment(amount)
// The same method call should produce different behavior
// depending on the payment object.

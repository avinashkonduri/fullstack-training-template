import { Order } from "./Order";
import { Payment } from "./Payment";
import { UpiPayment } from "./UpiPayment";
import { CreditCardPayment } from "./CreditCardPayment";

const order = new Order(
    "ORD1001",
    "Rahul",
    15000
);

// TODO: Display order information.

// TODO: Confirm the order.

// TODO: Display the order status.

// Polymorphism
const paymentMethods: Payment[] = [
    new UpiPayment(),
    new CreditCardPayment()
];

const amount = order.getTotalAmount();

// TODO:
// Loop through paymentMethods and call pay(amount).

// TODO:
// Test refund functionality by creating concrete payment objects.

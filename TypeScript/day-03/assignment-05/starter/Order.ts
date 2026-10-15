// Assignment 5: E-Commerce Order & Payment System

export class Order {

    public readonly orderId: string;
    public customerName: string;

    // TODO: Keep these properties private.
    private totalAmount: number;
    private status: string;

    constructor(
        orderId: string,
        customerName: string,
        totalAmount: number
    ) {
        this.orderId = orderId;
        this.customerName = customerName;

        // TODO: Validate initial amount.
        this.totalAmount = totalAmount;

        // TODO: Set initial status to PENDING.
        this.status = "PENDING";
    }

    public getTotalAmount(): number {
        // TODO
        return 0;
    }

    public addAmount(amount: number): void {
        // TODO:
        // Validate amount and add it to totalAmount.
    }

    public confirmOrder(): void {
        // TODO: Change status to CONFIRMED.
    }

    public cancelOrder(): void {
        // TODO: Change status to CANCELLED.
    }

    public getStatus(): string {
        // TODO
        return "";
    }
}

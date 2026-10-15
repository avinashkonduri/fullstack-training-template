# Assignment 4: Notification Service – Interfaces

## Objective

Build a notification system using a TypeScript **Interface**.

The company wants to send notifications through multiple channels without changing the main application logic.

## Concepts Covered

- `interface`
- `implements`
- Contract-based programming
- Multiple implementations
- Polymorphism
- Arrays of interface types

## Business Scenario

An application can send notifications through:

- Email
- SMS
- Push Notification

Every notification channel must support:

```text
send(message: string): void
```

## Requirements

Create an interface:

```ts
interface NotificationService
```

The interface must define:

```text
send(message: string): void
```

Create these classes:

```text
EmailNotification
SmsNotification
PushNotification
```

All three classes must implement the interface.

## Expected Behavior

### Email

```text
Email notification sent: Your order has been shipped
```

### SMS

```text
SMS notification sent: Your order has been shipped
```

### Push

```text
Push notification sent: Your order has been shipped
```

## Polymorphism Requirement

Use:

```ts
const services: NotificationService[] = [
    new EmailNotification(),
    new SmsNotification(),
    new PushNotification()
];
```

The application should call:

```ts
service.send(message);
```

without knowing the concrete notification class.

## Folder Structure

```text
assignment-04/
├── README.md
└── starter/
    ├── NotificationService.ts
    ├── EmailNotification.ts
    ├── SmsNotification.ts
    ├── PushNotification.ts
    └── main.ts
```

## How to Run

```bash
tsc starter/*.ts
node starter/main.js
```

## Important

The interface should contain the contract only.

Do not put implementation logic inside the interface.

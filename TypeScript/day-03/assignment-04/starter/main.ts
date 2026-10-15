import { NotificationService } from "./NotificationService";
import { EmailNotification } from "./EmailNotification";
import { SmsNotification } from "./SmsNotification";
import { PushNotification } from "./PushNotification";

const services: NotificationService[] = [
    new EmailNotification(),
    new SmsNotification(),
    new PushNotification()
];

const message = "Your order has been shipped";

// TODO:
// Loop through services and call send(message)

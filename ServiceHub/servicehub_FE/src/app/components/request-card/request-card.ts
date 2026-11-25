import { Component, input, Input } from '@angular/core';
import { ServiceRequest } from '../../models/service-request.model';
import { NgClass } from '@angular/common';

@Component({
  selector: 'app-request-card',
  imports: [NgClass],
  templateUrl: './request-card.html',
  styleUrl: './request-card.css',
})
export class RequestCard {
  // @Input({ required: true })
  // request!: ServiceRequest;

  request = input.required<ServiceRequest>();
}

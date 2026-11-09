import { Component, inject, OnInit, signal } from '@angular/core';
import { ActivatedRoute, Router, RouterLink, RouterModule } from '@angular/router';
import { ServiceRequestService } from '../../service/service-request';
import { ServiceRequest } from '../../models/service-request.model';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-srdetails',
  imports: [CommonModule, RouterModule],
  templateUrl: './srdetails.html',
  styleUrl: './srdetails.css',
})
export class SRDetails implements OnInit {

  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private service = inject(ServiceRequestService);

  request = signal<ServiceRequest | null>(null);
  loading = signal(true);
  errorMessage = signal('');

  ngOnInit(): void {

    const id = Number(this.route.snapshot.paramMap.get('id'));

    if (!id || Number.isNaN(id)) {
      this.errorMessage.set('Invalid service request ID');
      this.loading.set(false);
      return;
    }

    this.loadRequest(id);
  }

  loadRequest(id: number): void {

    this.loading.set(true);

    this.service.getRequestById(id).subscribe({
      next: (response) => {

        if (response.success) {
          this.request.set(response.data);
        } else {
          this.errorMessage.set('Unable to load service request');
        }

        this.loading.set(false);
      },

      error: () => {
        this.errorMessage.set('Service request not found');
        this.loading.set(false);
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/service-requests']);
  }

  editRequest(): void {
    const request = this.request();

    if (request) {
      this.router.navigate(['/service-requests', 'edit', request.id]);
    }
  }
}

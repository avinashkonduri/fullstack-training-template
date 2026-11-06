import { HttpClient } from '@angular/common/http';
import { Component, computed, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { ServiceRequest } from '../../models/service-request.model';
// Team Member Model
interface TeamMember {
  initials: string;
  name: string;
  role: string;
  availability: string;
  avatarClass: string;
}

// Category Model
interface RequestCategory {
  name: string;
  percentage: number;
  cssClass: string;
}
@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [FormsModule, ReactiveFormsModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css',
})
export class DashboardComponent implements OnInit {
  private http = inject(HttpClient);
  private fb = inject(FormBuilder);

  serviceRequestForm: FormGroup = this.fb.group({
    id: [0],
    requestId: ['', Validators.required],
    title: ['', [Validators.required, Validators.minLength(5), Validators.maxLength(100)]],
    category: ['', Validators.required],
    priority: ['Medium', Validators.required],
    status: ['Open', Validators.required],
    assignedTo: [''],
    requestedBy: ['', Validators.required],
    createdAt: [new Date().toISOString().split('T')[0]],
    description: ['', [Validators.required, Validators.minLength(10), Validators.maxLength(500)]],
  });

  categories = ['Hardware', 'Software', 'Network', 'Email', 'Access Management', 'Other'];

  priorities = ['Low', 'Medium', 'High', 'Critical'];

  statuses = ['Open', 'In Progress', 'Waiting', 'Resolved'];
  serviceRequests = signal<ServiceRequest[]>([]);
  // 1. Dashboard information
  pageTitle = signal('Dashboard');

  pageDescription = signal("Here is what's happening with your service requests today.");

  footerText = signal('ServiceHub Training Project · Angular 21 Signals');

  // 2. Dashboard summary
  openRequests = signal(24);
  inProgressRequests = signal(12);
  resolvedRequests = signal(86);
  highPriorityRequests = signal(5);

  // 3. Search and status filter
  searchText = signal('');
  selectedStatus = signal('All');

  isLoading = signal(false);
  errorMessage = signal('');
  // 4. Service requests

  // 5. Category statistics
  requestCategories = signal<RequestCategory[]>([
    {
      name: 'Network',
      percentage: 32,
      cssClass: 'network-fill',
    },
    {
      name: 'Hardware',
      percentage: 26,
      cssClass: 'hardware-fill',
    },
    {
      name: 'Software',
      percentage: 24,
      cssClass: 'software-fill',
    },
    {
      name: 'Access',
      percentage: 18,
      cssClass: 'access-fill',
    },
  ]);

  // 6. Team availability
  teamMembers = signal<TeamMember[]>([
    {
      initials: 'RK',
      name: 'Ravi Kumar',
      role: 'Network Support',
      availability: 'Available',
      avatarClass: 'avatar-green',
    },
    {
      initials: 'AS',
      name: 'Anil Sharma',
      role: 'Application Support',
      availability: 'Busy',
      avatarClass: 'avatar-blue',
    },
    {
      initials: 'PR',
      name: 'Priya Reddy',
      role: 'Hardware Support',
      availability: 'Available',
      avatarClass: 'avatar-purple',
    },
  ]);

  // 7. Computed signal: filtered requests
  filteredRequests = computed(() => {
    const search = this.searchText().trim().toLowerCase();
    const status = this.selectedStatus();

    return this.serviceRequests().filter((request) => {
      const matchesSearch =
        request.requestId.toLowerCase().includes(search) ||
        request.title.toLowerCase().includes(search) ||
        request.category.toLowerCase().includes(search) ||
        request.assignedTo.toLowerCase().includes(search);

      const matchesStatus = status === 'All' || request.status === status;

      return matchesSearch && matchesStatus;
    });
  });

  ngOnInit(): void {
    this.loadRequests();
  }


  // 9. Event handler: View all requests
  viewAllRequests(): void {
    alert('View All Service Requests clicked!');
  }

  // 10. Event handler: Search
  onSearchChange(value: string): void {
    this.searchText.set(value);
  }

  // 11. Event handler: Status filter
  onStatusChange(value: string): void {
    this.selectedStatus.set(value);
  }

  // 12. Clear filters
  clearFilters(): void {
    this.searchText.set('');
    this.selectedStatus.set('All');
  }

  // 13. Dynamic priority CSS class
  getPriorityClass(priority: string): string {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'high';
      case 'medium':
        return 'medium';
      case 'low':
        return 'low';
      default:
        return '';
    }
  }

  // 14. Dynamic status CSS class
  getStatusClass(status: string): string {
    switch (status.toLowerCase()) {
      case 'in progress':
        return 'in-progress';
      case 'open':
        return 'open';
      case 'resolved':
        return 'resolved';
      case 'waiting':
        return 'waiting';
      default:
        return '';
    }
  }

  loadRequests(): void {
    this.isLoading.set(true);
    this.errorMessage.set('');

    this.http.get<ServiceRequest[]>('/data/service-requests.json').subscribe({
      next: (data) => {
        this.serviceRequests.set(data);
        this.isLoading.set(false);
      },
      error: (error) => {
        console.error('Failed to load service requests', error);
        this.errorMessage.set('Unable to load service requests. Please try again.');
        this.isLoading.set(false);
      },
    });
  }

    get f() {
    return this.serviceRequestForm.controls;
  }
  // 8. Event handler: Create Request
createRequest(): void {

  const requests = this.serviceRequests();

  // Generate next ID
  const nextId = requests.length
    ? Math.max(...requests.map(r => r.id)) + 1
    : 1001;

  // Generate next Request ID
  const maxRequestNumber = requests.reduce((max, request) => {
    const number = Number(request.requestId.split('-').at(-1));
    return Number.isNaN(number) ? max : Math.max(max, number);
  }, 0);

  const requestId = `SR-${new Date().getFullYear()}-${String(
    maxRequestNumber + 1
  ).padStart(3, '0')}`;

  // Reset form with default values
  this.serviceRequestForm.reset({
    id: nextId,
    requestId: requestId,
    title: '',
    category: '',
    priority: 'Medium',
    status: 'Open',
    assignedTo: '',
    requestedBy: '',
    createdAt: new Date().toISOString().split('T')[0],
    description: ''
  });

}
  onSubmit(): void {

  if (this.serviceRequestForm.invalid) {
    this.serviceRequestForm.markAllAsTouched();
    return;
  }

  // Get form data
  const newRequest: ServiceRequest =
    this.serviceRequestForm.getRawValue();

  // Update Signals
  this.serviceRequests.update(requests => [
    newRequest,
    ...requests
  ]);

  // Update dashboard summary
  this.openRequests.update(count => count + 1);

  // Close modal
  const modalElement = document.getElementById('exampleModal');

  // if (modalElement) {
  //   import('bootstrap').then(({ Modal }) => {
  //     Modal.getOrCreateInstance(modalElement).hide();
  //   });
  // }

  // Reset form
  this.serviceRequestForm.reset();

  console.log('Service Request Created:', newRequest);

}

  onReset(): void {

  this.serviceRequestForm.reset({
    id: 0,
    requestId: '',
    title: '',
    category: '',
    priority: 'Medium',
    status: 'Open',
    assignedTo: '',
    requestedBy: '',
    createdAt: new Date().toISOString().split('T')[0],
    description: ''
  });

}
}

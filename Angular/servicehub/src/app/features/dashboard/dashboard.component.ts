import { Component } from '@angular/core';

// Service Request Model
interface ServiceRequest {
  requestId: string;
  title: string;
  category: string;
  priority: string;
  status: string;
  assignedTo: string;
}

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
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent {


  // Page Information
  pageTitle: string = 'Dashboard';
  pageDescription: string =
    "Here is what's happening with your service requests today.";

  // Dashboard Summary
  openRequests: number = 24;
  inProgressRequests: number = 12;
  resolvedRequests: number = 86;
  highPriorityRequests: number = 5;

  // Service Requests
  serviceRequests: ServiceRequest[] = [
    {
      requestId: 'SR-10245',
      title: 'VPN connection issue',
      category: 'Network',
      priority: 'High',
      status: 'In Progress',
      assignedTo: 'Ravi Kumar'
    },
    {
      requestId: 'SR-10244',
      title: 'Laptop performance issue',
      category: 'Hardware',
      priority: 'Medium',
      status: 'Open',
      assignedTo: 'Unassigned'
    },
    {
      requestId: 'SR-10243',
      title: 'Outlook access request',
      category: 'Software',
      priority: 'Low',
      status: 'Resolved',
      assignedTo: 'Anil Sharma'
    },
    {
      requestId: 'SR-10242',
      title: 'New software installation',
      category: 'Access',
      priority: 'High',
      status: 'Waiting',
      assignedTo: 'Priya Reddy'
    }
  ];

  // Requests by Category
  requestCategories: RequestCategory[] = [
    {
      name: 'Network',
      percentage: 32,
      cssClass: 'network-fill'
    },
    {
      name: 'Hardware',
      percentage: 26,
      cssClass: 'hardware-fill'
    },
    {
      name: 'Software',
      percentage: 24,
      cssClass: 'software-fill'
    },
    {
      name: 'Access',
      percentage: 18,
      cssClass: 'access-fill'
    }
  ];

  // Team Availability
  teamMembers: TeamMember[] = [
    {
      initials: 'RK',
      name: 'Ravi Kumar',
      role: 'Network Support',
      availability: 'Available',
      avatarClass: 'avatar-green'
    },
    {
      initials: 'AS',
      name: 'Anil Sharma',
      role: 'Application Support',
      availability: 'Busy',
      avatarClass: 'avatar-blue'
    },
    {
      initials: 'PR',
      name: 'Priya Reddy',
      role: 'Hardware Support',
      availability: 'Available',
      avatarClass: 'avatar-purple'
    }
  ];

  // Footer Information
  footerText: string =
    'ServiceHub Training Project · Sample data for Angular fundamentals';

}

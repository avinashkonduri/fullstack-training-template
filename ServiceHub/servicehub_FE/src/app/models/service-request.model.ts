
export interface ServiceRequest {
  requestId: string;
  title: string;
  category: string;
  priority: 'Low' | 'Medium' | 'High' | 'Critical';
  status: 'Open' | 'In Progress' | 'Waiting' | 'Resolved';
  assignedTo: string;
  requestedBy: string;
  createdAt: string;
  description: string;
}

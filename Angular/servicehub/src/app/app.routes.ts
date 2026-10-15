import { Routes } from '@angular/router';
import { DashboardComponent } from './features/dashboard/dashboard.component';
import { ServiceRequestsComponent } from './features/service-requests/service-requests.component';
import { AboutComponent } from './features/about/about.component';

export const routes: Routes = [
  { path: '', component: DashboardComponent, title: 'ServiceHub | Dashboard' },
  { path: 'dashboard', component: DashboardComponent, title: 'ServiceHub | Dashboard' },
  { path: 'service-requests', component: ServiceRequestsComponent, title: 'ServiceHub | Service Requests' },
  { path: 'about', component: AboutComponent, title: 'ServiceHub | About' },
  { path: '**', redirectTo: '' }
];

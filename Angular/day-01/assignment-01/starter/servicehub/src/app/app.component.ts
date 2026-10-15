import { Component } from '@angular/core';
import { AppHeaderComponent } from './shared/components/app-header/app-header.component';
import { AppSidebarComponent } from './shared/components/app-sidebar/app-sidebar.component';
import { DashboardComponent } from './features/dashboard/dashboard.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [AppHeaderComponent, AppSidebarComponent, DashboardComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {}

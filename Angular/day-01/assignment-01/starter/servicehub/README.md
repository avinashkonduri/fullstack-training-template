# ServiceHub – IT Service & Support Management System

A corporate IT Service Management (ITSM) and Helpdesk application inspired by platforms such as ServiceNow and Jira Service Management. ServiceHub enables employees to raise service requests and allows support teams to assign, investigate, resolve, approve, and monitor requests through a centralized system.

## 1. Project Overview

### Project Name
**ServiceHub – IT Service & Support Management System**

### Project Vision

Build an enterprise-style application that manages the complete service request lifecycle, from request creation to resolution and closure.

The application will provide role-based access, request tracking, team assignments, approval workflows, SLA monitoring, notifications, reporting, and administration.

### Business Scenario

An employee encounters a VPN connectivity issue and raises a service request.

```yaml
Request ID: SR-10245
Title: VPN Connection Issue
Category: Network
Subcategory: VPN
Priority: High
Description: Unable to connect to corporate VPN
Location: Hyderabad
Created By: Raj Kumar
Status: Open
```

The support team receives the request, assigns it to an agent, investigates the problem, communicates with the employee, and provides a resolution.

### Request Lifecycle

```text
Open
  |
  v
Assigned
  |
  v
In Progress
  |
  +----> Waiting for User
  |             |
  |             v
  +<------ In Progress
  |
  v
Resolved
  |
  v
Closed
```

Additional transitions, such as escalation, rejection, cancellation, and reopening, can be introduced based on business rules.

---

## 2. Project Objectives

- Build a realistic enterprise application using Angular.
- Implement role-based UI rendering and authorization.
- Manage service requests from creation through closure.
- Provide dashboards with meaningful business metrics.
- Implement request assignment, priority management, and approval workflows.
- Track request history through an activity timeline.
- Support comments, investigation notes, and attachments.
- Monitor Service Level Agreements (SLAs).
- Generate reports and export request data.
- Practice reusable components, reactive forms, routing, RxJS, and state management.
- Integrate the frontend with REST APIs and a backend service.

---

## 3. Main Application Modules

```text
ServiceHub
|
+-- Authentication
|   +-- Login
|   +-- Logout
|   +-- Password Management
|   +-- Session Management
|
+-- Dashboard
|   +-- Employee Dashboard
|   +-- Support Dashboard
|   +-- Team Lead Dashboard
|   +-- Admin Dashboard
|
+-- Service Requests
|   +-- Create Request
|   +-- Request List
|   +-- Request Details
|   +-- Edit Request
|   +-- Assign Request
|   +-- Change Status
|   +-- Resolve and Close
|
+-- My Requests
|   +-- My Open Requests
|   +-- My Resolved Requests
|   +-- Request History
|
+-- Assigned Requests
|   +-- My Assigned Requests
|   +-- Investigation
|   +-- Resolution Notes
|
+-- Approvals
|   +-- Pending Approvals
|   +-- Approval History
|   +-- Approve or Reject
|
+-- Knowledge Base
|   +-- Articles
|   +-- Categories
|   +-- Search Articles
|
+-- Assets
|   +-- Asset Inventory
|   +-- Asset Details
|   +-- Asset Assignment
|
+-- Notifications
|   +-- In-App Notifications
|   +-- Request Updates
|   +-- SLA Alerts
|
+-- Reports
|   +-- Request Reports
|   +-- Category Reports
|   +-- Agent Performance
|   +-- SLA Reports
|   +-- Export Reports
|
+-- Administration
    +-- User Management
    +-- Team Management
    +-- Category Management
    +-- Priority Management
    +-- Location Management
    +-- Asset Management
    +-- SLA Configuration
    +-- System Settings
```

---

## 4. User Roles and Responsibilities

ServiceHub will support four primary roles.

### 4.1 Employee

Employees can raise requests and track their progress.

**Permissions and features:**

- Log in and access the employee dashboard.
- Create service requests.
- View and search their own requests.
- Add comments and upload attachments.
- View request status and activity history.
- Respond to requests awaiting user information.
- Confirm resolution or request reopening, subject to business rules.
- Access relevant knowledge base articles.
- Receive notifications about request updates.

### 4.2 Support Agent

Support agents investigate and resolve assigned requests.

**Permissions and features:**

- View assigned requests.
- Accept and start working on requests.
- Update request status.
- Add investigation notes.
- Communicate with employees through comments.
- Record resolution details.
- Link relevant knowledge base articles.
- Monitor their workload and SLA deadlines.

### 4.3 Team Lead

Team leads supervise support teams and manage workload distribution.

**Permissions and features:**

- View requests across their team.
- Assign or reassign requests to agents.
- Change request priority according to policy.
- Approve escalations.
- Monitor team workload and performance.
- Review SLA breaches and approaching deadlines.
- Track unresolved and overdue requests.
- Review team reports.

### 4.4 Administrator

Administrators configure and maintain the application.

**Permissions and features:**

- Create, update, and deactivate users.
- Manage roles and teams.
- Configure request categories and subcategories.
- Manage priorities and locations.
- Maintain asset inventory.
- Configure SLA rules.
- Manage approval policies.
- Configure system settings.
- Access administrative reports.

**Security principle:** Hiding a menu or button in Angular is not sufficient authorization. The backend must independently validate permissions for protected operations.

---

## 5. Role-Based Navigation

The application should display navigation items according to the authenticated user's role.

| Module | Employee | Agent | Team Lead | Admin |
|---|---|---|---|---|
| Dashboard | Yes | Yes | Yes | Yes |
| Create Request | Yes | Optional | Optional | Optional |
| My Requests | Yes | Yes | Yes | Yes |
| Assigned Requests | No | Yes | Yes | Optional |
| Team Requests | No | No | Yes | Optional |
| Approvals | Optional | Optional | Yes | Yes |
| Knowledge Base | Yes | Yes | Yes | Yes |
| Assets | View as permitted | View as permitted | View as permitted | Manage |
| Reports | Personal | Personal/team | Team | All |
| Administration | No | No | Limited | Yes |

The exact permissions should be configurable according to organizational policy.

---

## 6. Dashboard Requirements

Each role should receive a dashboard relevant to its responsibilities.

### 6.1 Employee Dashboard

Display summary cards for:

- My Requests
- Open Requests
- In Progress
- Resolved Requests
- Waiting for User

Example:

| Metric | Count |
|---|---:|
| My Requests | 12 |
| Open | 5 |
| Resolved | 6 |
| Waiting for User | 1 |

Additional sections:

- Recently created requests.
- Recent activity.
- Pending responses.
- Request status distribution.
- Quick action to create a request.

### 6.2 Support Dashboard

Display:

- Total Requests
- Open Requests
- In Progress
- Critical Requests
- SLA Breached
- Resolved Today

Example:

| Metric | Count |
|---|---:|
| Total Requests | 1,245 |
| Open Requests | 185 |
| In Progress | 72 |
| Critical | 12 |
| SLA Breached | 8 |
| Resolved Today | 46 |

These values are sample data for the UI and must eventually come from backend APIs.

### 6.3 Dashboard Charts

- Requests by category.
- Requests by priority.
- Requests by status.
- Requests created versus resolved.
- SLA compliance.
- Agent workload and resolution performance.

---

## 7. Service Request Module

The Service Request module is the core of ServiceHub.

### 7.1 Request List

Display requests in a searchable, filterable, and sortable table.

| Request ID | Title | Priority | Assigned Agent | Status |
|---|---|---|---|---|
| SR-1001 | VPN Issue | High | Ravi | Open |
| SR-1002 | Laptop Problem | Medium | Kumar | In Progress |
| SR-1003 | Email Access | Low | Anil | Resolved |
| SR-1004 | Software Installation | High | Priya | Waiting for User |

### 7.2 Request List Features

- Global search.
- Search by request ID and title.
- Filter by status.
- Filter by priority.
- Filter by category.
- Filter by assigned agent.
- Filter by department or location.
- Date-range filtering.
- Column sorting.
- Pagination.
- Clear filters.
- Export to CSV or Excel.
- Role-based action buttons.

### 7.3 Create Request Form

Fields:

- Title.
- Description.
- Category.
- Subcategory.
- Priority.
- Location.
- Related asset.
- Attachments.

System-generated fields:

- Request ID.
- Created By.
- Created Date.
- Initial Status.
- SLA Due Date, when applicable.

Use Angular Reactive Forms with validation, reusable form controls, and clear error messages.

### 7.4 Request Details Page

Example:

```text
SR-10245 — VPN Connection Issue

Employee
Raj Kumar

Department
Finance

Priority
HIGH

Category
Network

Status
IN PROGRESS

Assigned To
Ravi Kumar

Description
Unable to connect to corporate VPN
since 9:30 AM.

--------------------------------------------------

Activity Timeline

10:20 — Request Created
10:35 — Assigned to Ravi
10:42 — Investigation Started
11:05 — Comment Added
11:20 — Resolution Provided

--------------------------------------------------

Comments

Raj:
VPN is still not connecting.

Ravi:
Please restart the VPN client.

--------------------------------------------------

Actions

[Add Comment] [Change Status] [Resolve]
```

The timestamps above are illustrative.

### 7.5 Request Details Features

- Request summary.
- Employee and department information.
- Assignment details.
- Status and priority indicators.
- Description and attachments.
- Activity timeline.
- Public comments.
- Internal investigation notes.
- Status change history.
- SLA countdown and breach indicators.
- Resolution summary.
- Related assets and knowledge articles.
- Role-based action controls.

---

## 8. Comments and Activity Timeline

Maintain an auditable history of request activity.

Each activity entry may include:

- Activity ID.
- Request ID.
- Activity type.
- Description.
- Performed By.
- Timestamp.
- Visibility.
- Previous and new values, where applicable.

Example activity types:

```text
REQUEST_CREATED
REQUEST_ASSIGNED
STATUS_CHANGED
PRIORITY_CHANGED
COMMENT_ADDED
ATTACHMENT_UPLOADED
ESCALATION_APPROVED
REQUEST_RESOLVED
REQUEST_CLOSED
```

Distinguish between employee-visible comments and internal notes. Employees must not be able to access internal investigation notes.

---

## 9. Approval Module

The approval module supports requests that require authorization.

Example use cases:

- New laptop requests.
- Software license requests.
- Access permission requests.
- High-cost asset requests.
- Privileged access requests.

### Approval Workflow

```text
Request Created
      |
      v
Approval Required?
      |
      +---- No ----> Assign to Support
      |
      +---- Yes
             |
             v
       Pending Approval
             |
       +-----+-----+
       |           |
       v           v
    Approved    Rejected
       |           |
       v           v
   Processing    Notify User
```

Features:

- Pending approval list.
- Approve or reject actions.
- Approval comments.
- Approval history.
- Notifications.
- Configurable approval rules.

---

## 10. Knowledge Base Module

Provide self-service articles that help employees resolve common issues.

Features:

- Article listing and details.
- Full-text search.
- Category-based browsing.
- Frequently viewed articles.
- Related articles.
- Helpful/not helpful feedback.
- Article creation and maintenance for authorized users.

Example categories:

- Network and VPN.
- Hardware.
- Software.
- Email.
- Account Access.
- Security.

---

## 11. Assets Module

Maintain an inventory of corporate IT assets.

Example asset:

```yaml
Asset ID: AST-1001
Asset Name: Dell Latitude Laptop
Asset Type: Laptop
Serial Number: DELL-ABC-123
Assigned To: Raj Kumar
Department: Finance
Location: Hyderabad
Status: Assigned
```

Features:

- Asset inventory.
- Asset search and filtering.
- Asset details.
- Assignment to employees.
- Asset status management.
- Link assets to service requests.
- Track maintenance history.

---

## 12. Notifications Module

Notify users when important events occur.

Examples:

- Request successfully created.
- Request assigned to an agent.
- Request status changed.
- Additional information requested.
- Request approved or rejected.
- SLA deadline approaching.
- SLA breached.
- Request resolved or closed.

Notification fields may include:

- Notification ID.
- Recipient ID.
- Title.
- Message.
- Notification Type.
- Related Request ID.
- Created Date.
- Read Status.

Potential future enhancements include email notifications, browser notifications, and real-time updates using WebSockets.

---

## 13. SLA Management

Service Level Agreements define target response and resolution times.

Example configuration:

| Priority | First Response Target | Resolution Target |
|---|---|---|
| Critical | 15 minutes | 4 hours |
| High | 30 minutes | 8 hours |
| Medium | 4 hours | 2 business days |
| Low | 8 hours | 5 business days |

These are sample training values, not universal standards.

Features:

- Configurable response targets.
- Configurable resolution targets.
- SLA countdown.
- Approaching-deadline warnings.
- SLA breach indicators.
- Breach reports.
- Business-hours and holiday calendars.

SLA calculations should be handled by the backend, including business calendars and any pause rules for waiting states.

---

## 14. Reports Module

Provide operational insights for agents, team leads, and administrators.

### Reports

1. Requests by Status.
2. Requests by Priority.
3. Requests by Category.
4. Requests by Department.
5. Requests by Location.
6. Agent Workload.
7. Resolution Time Analysis.
8. SLA Compliance.
9. Overdue Requests.
10. Monthly Request Trends.

### Report Features

- Date-range selection.
- Filter by team, category, status, and priority.
- Summary metrics.
- Tables and charts.
- CSV/Excel export.
- Role-based access to reports.

---

## 15. Administration Module

The Administration module manages reference data and system configuration.

### User Management
- Create users.
- Update user information.
- Assign roles.
- Assign teams.
- Activate or deactivate users.

### Team Management
- Create support teams.
- Assign team leads.
- Add or remove agents.
- Configure team membership.

### Category Management
- Create categories and subcategories.
- Activate or deactivate categories.

### Priority Management
- Configure priority levels.
- Define ordering and display labels.

### Location Management
- Maintain office locations.
- Associate locations with departments or assets.

### System Configuration
- Configure request rules.
- Configure SLA policies.
- Manage approval rules.
- Configure notification preferences.

---

## 16. Angular Technical Architecture

The frontend should be organized into reusable, feature-oriented modules.

```text
src/
└── app/
    ├── core/
    │   ├── auth/
    │   ├── guards/
    │   ├── interceptors/
    │   ├── services/
    │   └── models/
    │
    ├── shared/
    │   ├── components/
    │   ├── directives/
    │   ├── pipes/
    │   └── utilities/
    │
    ├── layout/
    │   ├── shell/
    │   ├── sidebar/
    │   ├── header/
    │   └── breadcrumbs/
    │
    ├── features/
    │   ├── dashboard/
    │   ├── service-requests/
    │   ├── my-requests/
    │   ├── assigned-requests/
    │   ├── approvals/
    │   ├── knowledge-base/
    │   ├── assets/
    │   ├── notifications/
    │   ├── reports/
    │   └── administration/
    │
    ├── app.config.ts
    ├── app.routes.ts
    └── app.component.ts
```

Use standalone components and route-level lazy loading where appropriate for the selected Angular version.

### Recommended Angular Concepts

| Concept | Application |
|---|---|
| Standalone Components | Feature screens and reusable UI |
| Angular Router | Feature navigation |
| Route Guards | Authentication and role-aware navigation |
| Reactive Forms | Create and edit request forms |
| `@if` and `@for` | Conditional UI and list rendering |
| `@Input` and `@Output` | Parent-child communication |
| Services | Business logic and API access |
| Dependency Injection | Shared services and abstractions |
| HttpClient | REST API communication |
| RxJS | Asynchronous data streams |
| Signals | Local and shared reactive UI state |
| Custom Directives | Reusable DOM behavior |
| Pipes | Date, status, and display formatting |
| Interceptors | Authentication headers and HTTP error handling |
| Lazy Loading | Load feature routes on demand |
| NgRx (optional) | Complex shared application state |
| Unit Testing | Component, service, and utility testing |

---

## 17. Recommended Technology Stack

### Frontend
- Angular.
- TypeScript.
- HTML5.
- CSS3.
- Bootstrap or Tailwind CSS.
- RxJS.
- Angular Reactive Forms.
- A charting library such as Chart.js.

### Backend
- Java with Spring Boot.
- RESTful APIs.
- Spring Security.
- Role-based authorization.

### Database
- PostgreSQL.

### Supporting Tools
- Git and GitHub.
- Postman for API testing.
- Swagger/OpenAPI for API documentation.
- Docker for containerization.
- GitHub Actions or another CI/CD solution.

The backend, database, and deployment technologies are proposed choices and can be replaced if required by the training environment.

---

## 18. Core Data Models

The application may initially use the following entities.

### User
- `id`
- `employeeCode`
- `fullName`
- `email`
- `departmentId`
- `teamId`
- `role`
- `active`

### ServiceRequest
- `id`
- `requestNumber`
- `title`
- `description`
- `categoryId`
- `subcategoryId`
- `priorityId`
- `status`
- `createdById`
- `assignedToId`
- `teamId`
- `assetId`
- `locationId`
- `createdAt`
- `updatedAt`
- `resolvedAt`
- `closedAt`

### Comment
- `id`
- `requestId`
- `authorId`
- `content`
- `visibility`
- `createdAt`

### RequestActivity
- `id`
- `requestId`
- `activityType`
- `performedById`
- `description`
- `createdAt`

### Attachment
- `id`
- `requestId`
- `uploadedById`
- `fileName`
- `contentType`
- `storageReference`
- `createdAt`

### Approval
- `id`
- `requestId`
- `approverId`
- `status`
- `comments`
- `decidedAt`

### Additional Entities
- Team.
- Department.
- Category.
- Subcategory.
- Priority.
- Location.
- Asset.
- SLA Policy.
- Notification.
- Knowledge Article.

Use foreign keys and appropriate indexes in the database. Store attachment metadata separately from file content, and enforce authorization when files are downloaded.

---

## 19. API Design

Proposed REST endpoints:

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/api/auth/login` | Authenticate |
| GET | `/api/dashboard/summary` | Retrieve dashboard metrics |
| GET | `/api/requests` | List and filter requests |
| POST | `/api/requests` | Create a request |
| GET | `/api/requests/{id}` | Retrieve request details |
| PUT | `/api/requests/{id}` | Update permitted request fields |
| PATCH | `/api/requests/{id}/status` | Change request status |
| PATCH | `/api/requests/{id}/assignment` | Assign or reassign |
| GET | `/api/requests/{id}/activities` | Retrieve activity history |
| GET | `/api/requests/{id}/comments` | Retrieve visible comments |
| POST | `/api/requests/{id}/comments` | Add a comment |
| POST | `/api/requests/{id}/attachments` | Upload an attachment |
| GET | `/api/approvals` | Retrieve approval tasks |
| PATCH | `/api/approvals/{id}` | Approve or reject |
| GET | `/api/knowledge-articles` | Search knowledge articles |
| GET | `/api/assets` | List assets |
| GET | `/api/reports/requests` | Retrieve request report data |

These endpoints are an initial contract proposal. Request IDs, validation rules, authentication mechanisms, and permission checks must be defined during backend implementation.

---

## 20. Security Requirements

- Authenticate users before granting access to protected screens.
- Enforce role and resource-level authorization on the backend.
- Validate all input on both frontend and backend.
- Restrict users to requests they are permitted to view or modify.
- Protect internal investigation notes.
- Validate attachment size, content type, and access permissions.
- Keep credentials and secrets out of source control.
- Record important actions in an audit trail.
- Use HTTPS in deployed environments.
- Apply secure session or token management.

---

## 21. Development Roadmap

### Phase 1 — Foundation
- Create the Angular application.
- Configure routes and the application layout.
- Build the header, sidebar, and navigation.
- Create reusable UI components.
- Add sample data.

### Phase 2 — Service Request Management
- Implement request listing.
- Build the create request form.
- Implement request details.
- Add search, filtering, sorting, and pagination.
- Add comments and activity history.

### Phase 3 — Role-Based Workflows
- Implement authentication integration.
- Configure role-aware navigation.
- Implement agent assignment.
- Implement status transitions.
- Add team lead and approval workflows.

### Phase 4 — Dashboards and Reporting
- Build role-specific dashboards.
- Add charts and summary cards.
- Implement report filters.
- Add CSV/Excel export.

### Phase 5 — Enterprise Features
- Implement knowledge base.
- Implement asset management.
- Add notifications.
- Configure SLA monitoring.
- Add administration screens.

### Phase 6 — Backend Integration and Quality
- Integrate Spring Boot REST APIs.
- Connect PostgreSQL.
- Implement server-side authorization.
- Add unit and integration tests.
- Validate error handling and loading states.
- Containerize and deploy the application.

---

## 22. Initial Minimum Viable Product (MVP)

Build these features first:

1. Login screen and application layout.
2. Role-aware navigation.
3. Dashboard with summary cards.
4. Service request list.
5. Create request form.
6. Request details page.
7. Agent assignment.
8. Status updates.
9. Comments and activity timeline.
10. Search, filters, and pagination.

After completing the MVP, add approvals, assets, notifications, reports, and SLA management.

---

## 23. Acceptance Criteria

The initial application is considered functional when:

- Users can navigate to permitted application screens.
- Employees can create and view their own service requests.
- Agents can access assigned requests and update their status.
- Team leads can assign requests and monitor team workloads.
- Administrators can manage reference data.
- Request details display comments and activity history.
- Search and filters produce the expected results.
- Forms display validation errors.
- Unauthorized operations are rejected by the backend.
- Loading, empty, and error states are handled.
- Automated tests cover critical workflows.

---

## 24. Expected Learning Outcomes

By completing ServiceHub, developers will gain practical experience in:

- Enterprise Angular application architecture.
- Component-driven UI development.
- Role-aware routing and authorization.
- Reactive forms and validation.
- API integration and error handling.
- RxJS and reactive state management.
- Reusable tables, filters, dialogs, and status indicators.
- Dashboard and chart development.
- Service request lifecycle management.
- Testing and maintainable code organization.
- Full-stack application development.

---

## 25. Future Enhancements

- Microfrontend architecture.
- NgRx-based state management.
- Real-time request updates using WebSockets.
- AI-powered knowledge article recommendations.
- Automatic request categorization.
- Intelligent ticket assignment.
- SLA breach prediction.
- Email integration.
- Advanced analytics and audit dashboards.
- Multi-department and multi-location support.

---

## Conclusion

**ServiceHub** is designed as a realistic enterprise ITSM training project rather than a basic CRUD application. Its modular architecture and service request workflows provide a practical foundation for learning Angular while progressively introducing backend integration, security, reporting, and enterprise application design.

The recommended approach is to complete the core request lifecycle first, validate it with realistic scenarios, and then extend the application with advanced enterprise capabilities.

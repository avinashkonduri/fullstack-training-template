import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ServiceRequest } from '../models/service-request.model';

@Injectable({
  providedIn: 'root',
})
export class ServiceRequestService {
  private http = inject(HttpClient);
  private readonly apiUrl = 'http://localhost:3000/api/service-requests';

  private readonly dataUrl = '/data/service-requests.json';

  getRequests(): Observable<any> {
    return this.http.get<ServiceRequest[]>(this.apiUrl);
  }

  getRequestById(id: number): Observable<any> {
  const url = `${this.apiUrl}/${id}`;
  return this.http.get<ServiceRequest>(url);  
}
}

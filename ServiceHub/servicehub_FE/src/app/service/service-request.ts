import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ServiceRequest } from '../models/service-request.model';

@Injectable({
  providedIn: 'root',
})
export class ServiceRequestService {
  private http = inject(HttpClient);

  private readonly dataUrl = '/data/service-requests.json';

  getRequests(): Observable<ServiceRequest[]> {
    return this.http.get<ServiceRequest[]>(this.dataUrl);
  }

  getRequestById(
    requestId: string
  ): Observable<ServiceRequest | undefined> {
    return new Observable<ServiceRequest | undefined>(subscriber => {
      this.getRequests().subscribe({
        next: requests => {
          subscriber.next(
            requests.find(request => request.requestId === requestId)
          );
          subscriber.complete();
        },
        error: error => subscriber.error(error)
      });
    });
  }
}

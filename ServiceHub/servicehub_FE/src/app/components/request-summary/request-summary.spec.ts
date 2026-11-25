import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RequestSummary } from './request-summary';

describe('RequestSummary', () => {
  let component: RequestSummary;
  let fixture: ComponentFixture<RequestSummary>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RequestSummary],
    }).compileComponents();

    fixture = TestBed.createComponent(RequestSummary);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

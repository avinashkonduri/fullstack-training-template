import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RequestFilter } from './request-filter';

describe('RequestFilter', () => {
  let component: RequestFilter;
  let fixture: ComponentFixture<RequestFilter>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RequestFilter],
    }).compileComponents();

    fixture = TestBed.createComponent(RequestFilter);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

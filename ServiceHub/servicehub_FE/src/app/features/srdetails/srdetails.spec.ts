import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SRDetails } from './srdetails';

describe('SRDetails', () => {
  let component: SRDetails;
  let fixture: ComponentFixture<SRDetails>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SRDetails],
    }).compileComponents();

    fixture = TestBed.createComponent(SRDetails);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

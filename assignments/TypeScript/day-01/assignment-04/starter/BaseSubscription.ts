// ==========================================
// 1. Base Class: BaseSubscription
// ==========================================

export class BaseSubscription {
  private _subscriberId: string;
  private _baseFee: number;
  private _maxStreams: number;

  constructor(subscriberId: string, baseFee: number, maxStreams: number = 1) {
    this._subscriberId = subscriberId;
    this._baseFee = baseFee;
    this._maxStreams = maxStreams;
  }

  public get subscriberId(): string {
    return this._subscriberId;
  }

  public get baseFee(): number {
    return this._baseFee;
  }

  public set baseFee(amount: number) {
    // TODO: Reject negative values
  }

  public get maxStreams(): number {
    return this._maxStreams;
  }

  public calculateBill(): number {
    return this._baseFee;
  }
}

// ==========================================
// 2. Subclass: PremiumSubscription
// ==========================================

export class PremiumSubscription extends BaseSubscription {
  private _has4KUltraHD: boolean;
  private static ULTRA_HD_FEE = 5;

  constructor(subscriberId: string, baseFee: number, has4K: boolean) {
    // TODO: Use super to initialize subscriberId, baseFee, and default 4 streams for premium
    this._has4KUltraHD = has4K;
  }

  public get has4KUltraHD(): boolean {
    return this._has4KUltraHD;
  }

  // Override calculateBill
  public override calculateBill(): number {
    // TODO: Get base bill using super.calculateBill()
    // Add ULTRA_HD_FEE if _has4KUltraHD is true
    return 0;
  }
}
// ==========================================
// 1. Base Class: SmartDevice
// ==========================================

export class SmartDevice {
  protected _deviceId: string;
  private _isOn: boolean = false;
  private _powerLevel: number = 100; // Percentage 0 - 100

  constructor(deviceId: string) {
    this._deviceId = deviceId;
  }

  public get deviceId(): string {
    return this._deviceId;
  }

  public get isOn(): boolean {
    return this._isOn;
  }

  public get powerLevel(): number {
    return this._powerLevel;
  }

  public set powerLevel(level: number) {
    // TODO: Cap values between 0 and 100
  }

  public turnOn(): void {
    this._isOn = true;
  }

  public turnOff(): void {
    this._isOn = false;
  }
}

// ==========================================
// 2. Subclass: SmartThermostat
// ==========================================

export class SmartThermostat extends SmartDevice {
  private _targetTemperature: number;

  constructor(deviceId: string, initialTemp: number) {
    // TODO: Pass deviceId to super constructor
    this._targetTemperature = initialTemp;
  }

  public get targetTemperature(): number {
    return this._targetTemperature;
  }

  public set targetTemperature(temp: number) {
    // TODO: Only update if temp is between 16°C and 30°C
  }

  // Custom turnOn method that calls super.turnOn()
  public override turnOn(): void {
    // TODO: Call super.turnOn() and log/track that HVAC control is initialized
  }
}
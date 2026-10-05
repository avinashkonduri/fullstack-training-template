# Assignment 3: Smart Home IoT Device System

## 🏠 Smart Devices & Thermostat

### 📌 Objective

Build a TypeScript-based Smart Home IoT Device System using:

- Classes and Objects
- Access Modifiers
- Getters and Setters
- Encapsulation
- Inheritance
- Method Overriding
- `super` keyword
- Validation and Error Handling

You will create a base `SmartDevice` class and a specialized `SmartThermostat` subclass.

---

# 📖 Problem Explanation

A smart home hub manages different connected appliances.

Every smart device has:

- Device ID
- Power status
- Power level

A smart thermostat extends the basic device functionality by adding:

- Target temperature
- Heating/Cooling status
- Specialized power-on behavior

---

# 1. Base Class: `SmartDevice`

Create a class called:

```typescript
SmartDevice
```

The class should contain the following properties:

```typescript
private _deviceId: string;
private _status: "on" | "off";
private _powerLevel: number;
```

The power level must always be between:

```text
0 and 100
```

---

# 2. Constructor

Create a constructor that accepts the device ID.

```typescript
constructor(deviceId: string)
```

The device should initially be:

```text
Status: off
Power Level: 0
```

Example:

```typescript
const device = new SmartDevice("DEV-001");
```

Expected initial state:

```text
Device ID: DEV-001
Status: off
Power Level: 0%
```

---

# 3. Device ID Getter

Create a getter for the device ID:

```typescript
public get deviceId(): string
```

The device ID should not be directly modified from outside the class.

Example:

```typescript
console.log(device.deviceId);
```

Expected:

```text
DEV-001
```

---

# 4. Status Getter

Create a getter:

```typescript
public get status(): "on" | "off"
```

The status should indicate whether the device is powered on or off.

Example:

```typescript
console.log(device.status);
```

Expected:

```text
off
```

---

# 5. Power Level Getter and Setter

Create:

```typescript
public get powerLevel(): number
```

and:

```typescript
public set powerLevel(value: number)
```

The power level must be between:

```text
0 and 100
```

---

## Validation

The setter must prevent invalid power levels.

### Valid values

```text
0
25
50
75
100
```

### Invalid values

```text
-10
101
150
```

You may handle invalid values using either:

### Option 1 – Throw an Error

```typescript
throw new Error("Power level must be between 0 and 100");
```

### Option 2 – Safely Cap the Value

For example:

```text
-20 → 0
150  → 100
```

Choose **one approach** and use it consistently.

---

# 6. `turnOn()` Method

Create:

```typescript
public turnOn(): void
```

This method should change the device status to:

```text
on
```

Example:

```typescript
device.turnOn();

console.log(device.status);
```

Expected:

```text
on
```

---

# 7. `turnOff()` Method

Create:

```typescript
public turnOff(): void
```

This method should change the device status to:

```text
off
```

Example:

```typescript
device.turnOff();

console.log(device.status);
```

Expected:

```text
off
```

---

# 8. Subclass: `SmartThermostat`

Create a class called:

```typescript
SmartThermostat
```

It must extend:

```typescript
SmartDevice
```

Example:

```typescript
export class SmartThermostat extends SmartDevice
```

The thermostat should have additional properties:

```typescript
private _targetTemperature: number;
private _mode: "heating" | "cooling" | "idle";
```

---

# 9. Thermostat Constructor

Create a constructor:

```typescript
constructor(
  deviceId: string,
  targetTemperature: number
)
```

Use `super()` to initialize the parent class.

Example:

```typescript
super(deviceId);
```

The initial thermostat mode should be:

```text
idle
```

---

# 10. Target Temperature Getter and Setter

Create:

```typescript
public get targetTemperature(): number
```

and:

```typescript
public set targetTemperature(value: number)
```

For this assignment, allow a reasonable temperature range such as:

```text
10°C to 35°C
```

If the value is outside this range, either:

- Throw an error, or
- Safely restrict it to the allowed range.

Example:

```text
20°C → Valid
25°C → Valid
35°C → Valid
5°C  → Invalid
40°C → Invalid
```

---

# 11. Thermostat Mode

Create a getter:

```typescript
public get mode(): "heating" | "cooling" | "idle"
```

The mode represents the thermostat's current operating state.

Possible values:

```text
heating
cooling
idle
```

---

# 12. Override `turnOn()`

Override the parent's `turnOn()` method.

```typescript
public override turnOn(): void
```

When the thermostat is turned on, it must first call the base class implementation:

```typescript
super.turnOn();
```

This ensures that the thermostat's basic device status becomes:

```text
on
```

After calling `super.turnOn()`, initialize the thermostat mode.

For example:

```typescript
this._mode = "heating";
```

You may choose an appropriate default behavior.

---

# 13. Override `turnOff()`

You should also override:

```typescript
public override turnOff(): void
```

Call the parent method:

```typescript
super.turnOff();
```

Then set:

```typescript
this._mode = "idle";
```

Therefore, when the thermostat is switched off:

```text
Status → off
Mode   → idle
```

---

# 🧑‍💻 Boilerplate Code

Use the following starter code.

```typescript
// ==========================================
// 1. Base Class: SmartDevice
// ==========================================

export class SmartDevice {
  private _deviceId: string;
  private _status: "on" | "off" = "off";
  private _powerLevel: number = 0;

  constructor(deviceId: string) {
    this._deviceId = deviceId;
  }

  public get deviceId(): string {
    return this._deviceId;
  }

  public get status(): "on" | "off" {
    return this._status;
  }

  public get powerLevel(): number {
    return this._powerLevel;
  }

  public set powerLevel(value: number) {
    // TODO:
    // Ensure power level is between 0 and 100.
    // Either throw an error or safely cap the value.
  }

  public turnOn(): void {
    // TODO:
    // Change device status to "on"
  }

  public turnOff(): void {
    // TODO:
    // Change device status to "off"
  }
}


// ==========================================
// 2. Subclass: SmartThermostat
// ==========================================

export class SmartThermostat extends SmartDevice {
  private _targetTemperature: number;
  private _mode: "heating" | "cooling" | "idle" = "idle";

  constructor(
    deviceId: string,
    targetTemperature: number
  ) {
    // TODO:
    // Call parent constructor using super()

    this._targetTemperature = targetTemperature;
  }

  public get targetTemperature(): number {
    return this._targetTemperature;
  }

  public set targetTemperature(value: number) {
    // TODO:
    // Validate temperature between 10 and 35 degrees.
  }

  public get mode(): "heating" | "cooling" | "idle" {
    return this._mode;
  }

  public override turnOn(): void {
    // TODO:
    // Call parent turnOn() using super.turnOn()
    // Then initialize thermostat mode.
  }

  public override turnOff(): void {
    // TODO:
    // Call parent turnOff() using super.turnOff()
    // Then set thermostat mode to "idle"
  }
}
```

---

# 🧪 Test Cases

## Test Case 1 – Smart Device

```typescript
const device = new SmartDevice("LIGHT-001");

console.log(device.deviceId);
console.log(device.status);
console.log(device.powerLevel);
```

Expected:

```text
LIGHT-001
off
0
```

---

## Test Case 2 – Turn Device On

```typescript
const device = new SmartDevice("LIGHT-001");

device.turnOn();

console.log(device.status);
```

Expected:

```text
on
```

---

## Test Case 3 – Turn Device Off

```typescript
device.turnOff();

console.log(device.status);
```

Expected:

```text
off
```

---

## Test Case 4 – Power Level

```typescript
const device = new SmartDevice("FAN-001");

device.powerLevel = 75;

console.log(device.powerLevel);
```

Expected:

```text
75
```

---

## Test Case 5 – Invalid Power Level

```typescript
const device = new SmartDevice("AC-001");

device.powerLevel = 150;
```

If you chose error handling, expected behavior:

```text
Error: Power level must be between 0 and 100
```

If you chose safe capping:

```text
100
```

---

# 🌡️ Test Case 6 – Smart Thermostat

```typescript
const thermostat = new SmartThermostat(
  "THERMO-001",
  24
);

console.log(thermostat.deviceId);
console.log(thermostat.targetTemperature);
console.log(thermostat.status);
console.log(thermostat.mode);
```

Expected:

```text
THERMO-001
24
off
idle
```

---

# 🔥 Test Case 7 – Turn Thermostat On

```typescript
thermostat.turnOn();

console.log(thermostat.status);
console.log(thermostat.mode);
```

Expected:

```text
on
heating
```

The important part is that `turnOn()` must call:

```typescript
super.turnOn();
```

---

# 🛑 Test Case 8 – Turn Thermostat Off

```typescript
thermostat.turnOff();

console.log(thermostat.status);
console.log(thermostat.mode);
```

Expected:

```text
off
idle
```

---

# 🌡️ Test Case 9 – Change Target Temperature

```typescript
thermostat.targetTemperature = 28;

console.log(thermostat.targetTemperature);
```

Expected:

```text
28
```

---

# ❌ Test Case 10 – Invalid Temperature

```typescript
thermostat.targetTemperature = 50;
```

The application should either throw an error or safely restrict the value.

---

# 🎯 Concepts You Must Demonstrate

| Concept | Requirement |
|---|---|
| Class | `SmartDevice` |
| Inheritance | `SmartThermostat extends SmartDevice` |
| Encapsulation | Private properties |
| Getter | Device ID |
| Getter/Setter | Power level |
| Getter/Setter | Target temperature |
| Validation | Power level 0–100 |
| Validation | Temperature 10–35 |
| Constructor | Initialize device |
| `super()` | Call parent constructor |
| `super.turnOn()` | Call parent method |
| `super.turnOff()` | Call parent method |
| Method Overriding | `turnOn()` / `turnOff()` |
| Access Modifiers | `private`, `public` |
| Error Handling | Invalid values |

---

# 📁 Suggested File Structure

```text
day-01/
│
├── assignment-01/
│   ├── README.md
│   └── solution.ts
│
├── assignment-02/
│   ├── README.md
│   └── solution.ts
│
└── assignment-03/
    ├── README.md
    └── solution.ts
```

---

# 📤 Submission Instructions

1. Create an `assignment-03` folder.
2. Create `README.md`.
3. Create `solution.ts`.
4. Copy the boilerplate code into `solution.ts`.
5. Complete all `TODO` sections.
6. Add the required test cases.
7. Test valid and invalid inputs.
8. Commit your changes.
9. Push the changes to your GitHub repository.

Example:

```bash
git add .
git commit -m "Complete Assignment 3 - Smart Home IoT Device System"
git push
```

---

# ✅ Submission Checklist

Before submitting, verify:

- [ ] `SmartDevice` class is implemented.
- [ ] `SmartThermostat` extends `SmartDevice`.
- [ ] Device ID is private.
- [ ] Device status is private.
- [ ] Power level is private.
- [ ] Power level getter/setter works.
- [ ] Power level validation works.
- [ ] `turnOn()` works.
- [ ] `turnOff()` works.
- [ ] `super()` is used in the thermostat constructor.
- [ ] Target temperature getter/setter works.
- [ ] Temperature validation works.
- [ ] Thermostat mode is implemented.
- [ ] `turnOn()` is overridden.
- [ ] `super.turnOn()` is called.
- [ ] `turnOff()` is overridden.
- [ ] `super.turnOff()` is called.
- [ ] Invalid inputs are handled safely.
- [ ] Test cases are working.
- [ ] Code is committed and pushed to GitHub.

---

# ⭐ Learning Outcome

After completing this assignment, you should understand how a real-world IoT device hierarchy can be designed using TypeScript.

```text
SmartDevice
│
├── deviceId
├── status
├── powerLevel
│
├── turnOn()
└── turnOff()
        │
        ▼
SmartThermostat
│
├── targetTemperature
├── mode
│
├── turnOn()
│     └── super.turnOn()
│
└── turnOff()
      └── super.turnOff()
```

### Key Takeaway

The child class should **reuse the functionality of the parent class** instead of duplicating it.

```typescript
super.turnOn();
```

allows `SmartThermostat` to reuse the `SmartDevice` implementation while adding its own thermostat-specific behavior.
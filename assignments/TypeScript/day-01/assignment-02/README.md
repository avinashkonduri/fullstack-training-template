# Assignment 2: Educational Learning Platform
## Courses & Lessons

### 📌 Objective

Build a TypeScript-based educational learning platform using:

- Classes and Objects
- Access Modifiers
- Getters and Setters
- Encapsulation
- Inheritance
- Method Overriding
- `super` keyword

You will create a base `Course` class and an `InteractiveCourse` subclass.

---

## 📖 Problem Explanation

An online education portal manages different types of learning content.

A **Course** contains:

- Course title
- Completion percentage
- Grade status

An **InteractiveCourse** extends the `Course` class and additionally contains:

- Lab score
- Additional grade requirements

---

# 1. Base Class: `Course`

Create a class called `Course`.

### Properties

The class should contain:

```typescript
private _title: string;
private _completionPercentage: number = 0;
```

### Requirements

#### Course Title

The course title should be initialized through the constructor.

```typescript
constructor(title: string)
```

The title should be accessible using a getter:

```typescript
public get title(): string
```

---

### Completion Percentage

The completion percentage must be private and accessed using a getter and setter.

```typescript
public get completionPercentage(): number
```

```typescript
public set completionPercentage(value: number)
```

The setter must validate the value.

### Validation Rule

The value must be between:

```text
0 and 100
```

If the value is within the valid range, update `_completionPercentage`.

If the value is outside the range, do not update the existing value.

### Examples

```text
completionPercentage = 50
→ Valid

completionPercentage = 100
→ Valid

completionPercentage = 0
→ Valid

completionPercentage = 120
→ Invalid

completionPercentage = -10
→ Invalid
```

---

# 2. `getGradeStatus()` Method

Create the following method:

```typescript
public getGradeStatus(): string
```

### Business Rule

The student passes the course when:

```text
completionPercentage >= 70
```

Otherwise, the course is incomplete.

### Expected Results

| Completion | Status |
|---:|---|
| 90 | PASS |
| 75 | PASS |
| 70 | PASS |
| 69 | INCOMPLETE |
| 40 | INCOMPLETE |

---

# 3. Subclass: `InteractiveCourse`

Create a class called:

```typescript
InteractiveCourse
```

It must extend the `Course` class.

```typescript
export class InteractiveCourse extends Course
```

The class should contain:

```typescript
private _labScore: number = 0;
```

The lab score must also be maintained using a getter and setter.

---

# 4. Constructor

The `InteractiveCourse` constructor should accept:

```typescript
constructor(title: string, initialLabScore: number)
```

Use the `super` keyword to call the parent constructor.

Example:

```typescript
super(title);
```

Then initialize the lab score using the setter:

```typescript
this.labScore = initialLabScore;
```

---

# 5. Lab Score Getter and Setter

Create:

```typescript
public get labScore(): number
```

and:

```typescript
public set labScore(score: number)
```

### Validation Rule

The lab score must be between:

```text
0 and 100
```

If the value is valid, update `_labScore`.

Otherwise, do not update the existing value.

### Examples

```text
labScore = 90
→ Valid

labScore = 80
→ Valid

labScore = 100
→ Valid

labScore = 120
→ Invalid

labScore = -5
→ Invalid
```

---

# 6. Override `getGradeStatus()`

Override the parent's `getGradeStatus()` method.

```typescript
public override getGradeStatus(): string
```

For an `InteractiveCourse`, the student passes only when **both** conditions are satisfied.

### Condition 1

```text
completionPercentage >= 70
```

### Condition 2

```text
labScore >= 80
```

### Final Rule

```text
completionPercentage >= 70
AND
labScore >= 80
```

If both conditions are true:

```text
PASS
```

Otherwise:

```text
FAIL
```

---

# 7. Using `super`

Inside the overridden method, retrieve the parent's completion percentage using the inherited getter.

You can access it through:

```typescript
super.completionPercentage
```

Then combine it with the lab score.

---

# 🧑‍💻 Boilerplate Code

Use the following starter code:

```typescript
// ==========================================
// 1. Base Class: Course
// ==========================================

export class Course {
  private _title: string;
  private _completionPercentage: number = 0;

  constructor(title: string) {
    this._title = title;
  }

  public get title(): string {
    return this._title;
  }

  public get completionPercentage(): number {
    return this._completionPercentage;
  }

  // Mutator with range check (0 - 100)
  public set completionPercentage(value: number) {
    // TODO: Ensure value is between 0 and 100
    // before setting _completionPercentage
  }

  public getGradeStatus(): string {
    // TODO:
    // Return "PASS" if completionPercentage >= 70
    // Otherwise return "INCOMPLETE"

    return "";
  }
}

// ==========================================
// 2. Subclass: InteractiveCourse
// ==========================================

export class InteractiveCourse extends Course {
  private _labScore: number = 0;

  constructor(title: string, initialLabScore: number) {
    // TODO: Call parent constructor using super

    this.labScore = initialLabScore;
  }

  public get labScore(): number {
    return this._labScore;
  }

  public set labScore(score: number) {
    if (score >= 0 && score <= 100) {
      this._labScore = score;
    }
  }

  // Override getGradeStatus
  // Pass only if:
  // completionPercentage >= 70
  // AND
  // labScore >= 80

  public override getGradeStatus(): string {
    // TODO:
    // Retrieve parent completion percentage
    // using getter/super logic.

    // Return "PASS" if both criteria are met,
    // otherwise return "FAIL"

    return "";
  }
}
```

---

# 🧪 Expected Test Cases

Create test objects to verify your implementation.

### Test Case 1 – Regular Course

```typescript
const course = new Course("TypeScript Fundamentals");

course.completionPercentage = 85;

console.log(course.title);
console.log(course.completionPercentage);
console.log(course.getGradeStatus());
```

Expected:

```text
TypeScript Fundamentals
85
PASS
```

---

### Test Case 2 – Incomplete Course

```typescript
const course = new Course("Angular Fundamentals");

course.completionPercentage = 60;

console.log(course.getGradeStatus());
```

Expected:

```text
INCOMPLETE
```

---

### Test Case 3 – Interactive Course – Pass

```typescript
const course = new InteractiveCourse(
  "Full Stack Development",
  90
);

course.completionPercentage = 85;

console.log(course.title);
console.log(course.completionPercentage);
console.log(course.labScore);
console.log(course.getGradeStatus());
```

Expected:

```text
Full Stack Development
85
90
PASS
```

---

### Test Case 4 – Completion Passed but Lab Failed

```typescript
const course = new InteractiveCourse(
  "JavaScript Advanced",
  70
);

course.completionPercentage = 90;

console.log(course.getGradeStatus());
```

Expected:

```text
FAIL
```

Reason:

```text
Completion = 90  ✅
Lab Score = 70   ❌
```

---

### Test Case 5 – Lab Passed but Completion Failed

```typescript
const course = new InteractiveCourse(
  "TypeScript Advanced",
  90
);

course.completionPercentage = 60;

console.log(course.getGradeStatus());
```

Expected:

```text
FAIL
```

Reason:

```text
Completion = 60  ❌
Lab Score = 90   ✅
```

---

# 🔍 Validation Test Cases

Test invalid values as well.

```typescript
const course = new Course("TypeScript");

course.completionPercentage = 80;

console.log(course.completionPercentage);

course.completionPercentage = 150;

console.log(course.completionPercentage);

course.completionPercentage = -20;

console.log(course.completionPercentage);
```

Expected:

```text
80
80
80
```

The invalid values should **not overwrite** the existing valid value.

---

# 🎯 Concepts You Must Demonstrate

Your solution should demonstrate all of the following:

| Concept | Requirement |
|---|---|
| Class | `Course` |
| Inheritance | `InteractiveCourse extends Course` |
| Encapsulation | Private properties |
| Getter | `completionPercentage`, `labScore` |
| Setter | `completionPercentage`, `labScore` |
| Validation | Values between 0 and 100 |
| Constructor | Initialize course information |
| `super()` | Call parent constructor |
| `super` getter | Access parent completion percentage |
| Method Overriding | `getGradeStatus()` |
| Access Modifiers | `private`, `public` |
| TypeScript | Proper types and syntax |

---

# 📁 Suggested File Structure

```text
day-01/
│
├── assignment-01/
│   ├── README.md
│   └── solution.ts
│
└── assignment-02/
    ├── README.md
    └── solution.ts
```

---

# 📤 Submission Instructions

1. Create an `assignment-02` folder.
2. Add the provided TypeScript boilerplate.
3. Complete all `TODO` sections.
4. Create test cases.
5. Verify all expected outputs.
6. Commit your changes.
7. Push the code to your assigned GitHub repository.

Example:

```bash
git add .
git commit -m "Complete Assignment 2 - Educational Learning Platform"
git push
```

---

# ✅ Submission Checklist

Before submitting, make sure:

- [ ] `Course` class is implemented.
- [ ] `InteractiveCourse` extends `Course`.
- [ ] Private properties are used.
- [ ] Getters are implemented.
- [ ] Setters are implemented.
- [ ] Completion percentage validation works.
- [ ] Lab score validation works.
- [ ] `super()` is used correctly.
- [ ] `super.completionPercentage` is used.
- [ ] `getGradeStatus()` is overridden.
- [ ] All test cases are working.
- [ ] Invalid values do not overwrite valid values.
- [ ] Code is committed and pushed to GitHub.

---

## ⭐ Learning Outcome

After completing this assignment, you should be able to explain and implement:

```text
Encapsulation
     │
     ├── private properties
     ├── getters
     └── setters
     
Inheritance
     │
     └── Course
           │
           └── InteractiveCourse

Method Overriding
     │
     └── getGradeStatus()

super
     │
     ├── super()
     └── super.completionPercentage
```

**Do not copy a completed solution. Implement the TODO sections yourself and test your solution with multiple inputs.**
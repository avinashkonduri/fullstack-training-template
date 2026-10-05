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
    // TODO: Ensure value is between 0 and 100 before setting _completionPercentage
  }

  public getGradeStatus(): string {
    // TODO: Return "PASS" if completionPercentage >= 70, else return "INCOMPLETE"
    return "";
  }
}

// ==========================================
// 2. Subclass: InteractiveCourse
// ==========================================

export class InteractiveCourse extends Course {
  private _labScore: number = 0; // 0 to 100

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

  // Override getGradeStatus: Pass only if completionPercentage >= 70 AND labScore >= 80
  public override getGradeStatus(): string {
    // TODO: Retrieve parent completion percentage using getter/super logic
    // Return "PASS" if both criteria are met, otherwise "FAIL"
    return "";
  }
}
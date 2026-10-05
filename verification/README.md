# Verification Scripts

## Files

### verify-assignment.ps1

Verifies one trainee.

Example:

```powershell
.\verify-assignment.ps1 `
    -TraineeId "FS001" `
    -Technology "TypeScript" `
    -Day "day-02" `
    -Assignment "assignment-01"
```

### verify-all.ps1

Verifies all trainees from `trainees.csv`.

Example:

```powershell
.\verify-all.ps1 `
    -Technology "TypeScript" `
    -Day "day-02" `
    -Assignment "assignment-01"
```

Dry run:

```powershell
.\verify-all.ps1 `
    -Technology "TypeScript" `
    -Day "day-02" `
    -Assignment "assignment-01" `
    -DryRun
```

## Hidden tests

Store tests under:

```text
tests/
└── TypeScript/
    └── day-02/
        └── assignment-01/
            └── assignment.test.cjs
```

Do NOT publish the `tests` folder to trainee repositories.

## Reports

Reports are generated under:

```text
reports/
└── verification/
```

The system records:

- Submission status
- Compilation status
- Passed tests
- Failed tests
- Score
- Final status
- Detailed test output

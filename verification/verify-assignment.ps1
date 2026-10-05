param(
    [Parameter(Mandatory = $true)]
    [string]$TraineeId,

    [Parameter(Mandatory = $true)]
    [string]$Technology,

    [Parameter(Mandatory = $true)]
    [string]$Day,

    [Parameter(Mandatory = $true)]
    [string]$Assignment,

    [string]$WorkPath = "",

    [string]$TestsPath = "",

    [string]$ReportsPath = ""
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

$ScriptRoot = Split-Path -Parent $PSScriptRoot
$BasePath = Split-Path -Parent $ScriptRoot

if ([string]::IsNullOrWhiteSpace($WorkPath)) {
    $WorkPath = Join-Path $BasePath "trainee-work"
}

if ([string]::IsNullOrWhiteSpace($TestsPath)) {
    $TestsPath = Join-Path $BasePath "tests"
}

if ([string]::IsNullOrWhiteSpace($ReportsPath)) {
    $ReportsPath = Join-Path $BasePath "reports\verification"
}

$TraineesFile = Join-Path $BasePath "trainees.csv"
$GitHubUser = "avinashkonduri"
$Branch = "main"

New-Item -ItemType Directory -Force -Path $WorkPath | Out-Null
New-Item -ItemType Directory -Force -Path $ReportsPath | Out-Null

# ------------------------------------------------------------
# Find trainee
# ------------------------------------------------------------

if (-not (Test-Path $TraineesFile)) {
    throw "trainees.csv not found: $TraineesFile"
}

$Trainees = @(Import-Csv $TraineesFile)

$Trainee = $Trainees |
    Where-Object { $_.TraineeId -eq $TraineeId } |
    Select-Object -First 1

if ($null -eq $Trainee) {
    throw "Trainee '$TraineeId' was not found in trainees.csv."
}

$Repository = $Trainee.Repository
$TraineeName = $Trainee.TraineeName

if ([string]::IsNullOrWhiteSpace($Repository)) {
    throw "Repository is missing for trainee $TraineeId."
}

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

$RepoUrl = "https://github.com/$GitHubUser/$Repository.git"
$LocalRepo = Join-Path $WorkPath $Repository

$SubmissionPath = Join-Path `
    $LocalRepo `
    "$Technology\$Day\$Assignment\submission"

$HiddenTestsPath = Join-Path `
    $TestsPath `
    "$Technology\$Day\$Assignment"

$HiddenTestFile = Join-Path `
    $HiddenTestsPath `
    "assignment.test.ts"

$ResultTimestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# ------------------------------------------------------------
# Display
# ------------------------------------------------------------

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "             TRAINEE ASSIGNMENT VERIFICATION" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Trainee    : $TraineeId - $TraineeName"
Write-Host "Repository : $Repository"
Write-Host "Technology : $Technology"
Write-Host "Day        : $Day"
Write-Host "Assignment : $Assignment"
Write-Host ""

# ------------------------------------------------------------
# Pull repository
# ------------------------------------------------------------

if (-not (Test-Path $LocalRepo)) {

    Write-Host "Cloning repository..." -ForegroundColor Gray

    git clone $RepoUrl $LocalRepo

    if ($LASTEXITCODE -ne 0) {
        throw "Git clone failed."
    }
}
else {

    Write-Host "Repository already exists locally."

    Push-Location $LocalRepo

    try {
        git checkout $Branch 2>$null

        if ($LASTEXITCODE -ne 0) {
            throw "Unable to checkout $Branch."
        }

        git pull origin $Branch

        if ($LASTEXITCODE -ne 0) {
            throw "Git pull failed."
        }
    }
    finally {
        Pop-Location
    }
}

# ------------------------------------------------------------
# Validate hidden tests
# ------------------------------------------------------------

if (-not (Test-Path $HiddenTestFile)) {

    throw @"
Hidden test file not found.

Expected:
$HiddenTestFile

Create the hidden test before running verification.
"@
}

# ------------------------------------------------------------
# Validate submission
# ------------------------------------------------------------

if (-not (Test-Path $SubmissionPath)) {

    Write-Host "SUBMISSION MISSING" -ForegroundColor Red

    $Result = [PSCustomObject]@{
        Timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TraineeId    = $TraineeId
        TraineeName  = $TraineeName
        Repository   = $Repository
        Technology   = $Technology
        Day          = $Day
        Assignment   = $Assignment
        Submission   = "MISSING"
        Compilation  = "NOT_RUN"
        Passed       = 0
        Failed       = 0
        Score        = 0
        Status       = "NOT_SUBMITTED"
        Message      = "Submission folder not found"
    }

    $ReportFile = Join-Path `
        $ReportsPath `
        "verification-$Technology-$Day-$Assignment-$TraineeId-$ResultTimestamp.csv"

    $Result | Export-Csv $ReportFile -NoTypeInformation -Encoding UTF8

    $Result | Format-List

    exit 0
}

Write-Host "Submission found." -ForegroundColor Green

# ------------------------------------------------------------
# Create isolated verification workspace
# ------------------------------------------------------------

$VerificationRoot = Join-Path `
    $env:TEMP `
    "fullstack-verification\$TraineeId-$Technology-$Day-$Assignment-$ResultTimestamp"

$SubmissionCopy = Join-Path $VerificationRoot "submission"
$TestsCopy = Join-Path $VerificationRoot "tests"
$CompiledPath = Join-Path $VerificationRoot "compiled"

New-Item -ItemType Directory -Force -Path $VerificationRoot | Out-Null
New-Item -ItemType Directory -Force -Path $SubmissionCopy | Out-Null
New-Item -ItemType Directory -Force -Path $TestsCopy | Out-Null
New-Item -ItemType Directory -Force -Path $CompiledPath | Out-Null

Copy-Item `
    "$SubmissionPath\*" `
    $SubmissionCopy `
    -Recurse `
    -Force

Copy-Item `
    "$HiddenTestsPath\*" `
    $TestsCopy `
    -Recurse `
    -Force

# ------------------------------------------------------------
# Locate TypeScript compiler
# ------------------------------------------------------------

$TscCommand = Get-Command tsc -ErrorAction SilentlyContinue

if ($null -eq $TscCommand) {

    Write-Host "Global TypeScript compiler not found. Trying npx tsc..." -ForegroundColor Yellow

    $TscCommandName = "npx"
    $TscArguments = @("tsc")
}
else {

    $TscCommandName = $TscCommand.Source
    $TscArguments = @()
}

# ------------------------------------------------------------
# Compile submission
# ------------------------------------------------------------

Write-Host ""
Write-Host "Compiling submission..." -ForegroundColor Cyan

$SubmissionFiles = @(Get-ChildItem `
    -Path $SubmissionCopy `
    -Filter "*.ts" `
    -Recurse `
    -File)

if ($SubmissionFiles.Count -eq 0) {

    Write-Host "No TypeScript files found in submission." -ForegroundColor Red

    $Result = [PSCustomObject]@{
        Timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TraineeId    = $TraineeId
        TraineeName  = $TraineeName
        Repository   = $Repository
        Technology   = $Technology
        Day          = $Day
        Assignment   = $Assignment
        Submission   = "FOUND"
        Compilation  = "FAILED"
        Passed       = 0
        Failed       = 0
        Score        = 0
        Status       = "COMPILE_ERROR"
        Message      = "No TypeScript files found"
    }

    $ReportFile = Join-Path `
        $ReportsPath `
        "verification-$Technology-$Day-$Assignment-$TraineeId-$ResultTimestamp.csv"

    $Result | Export-Csv $ReportFile -NoTypeInformation -Encoding UTF8

    exit 0
}

$SubmissionCompileOut = Join-Path $VerificationRoot "submission-compile"

New-Item -ItemType Directory -Force -Path $SubmissionCompileOut | Out-Null

& $TscCommandName @TscArguments `
    --target ES2022 `
    --module commonjs `
    --strict `
    --esModuleInterop `
    --skipLibCheck `
    --outDir $SubmissionCompileOut `
    --rootDir $SubmissionCopy `
    $SubmissionFiles.FullName

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "COMPILATION FAILED" -ForegroundColor Red

    $Result = [PSCustomObject]@{
        Timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TraineeId    = $TraineeId
        TraineeName  = $TraineeName
        Repository   = $Repository
        Technology   = $Technology
        Day          = $Day
        Assignment   = $Assignment
        Submission   = "FOUND"
        Compilation  = "FAILED"
        Passed       = 0
        Failed       = 0
        Score        = 0
        Status       = "COMPILE_ERROR"
        Message      = "TypeScript compilation failed"
    }

    $ReportFile = Join-Path `
        $ReportsPath `
        "verification-$Technology-$Day-$Assignment-$TraineeId-$ResultTimestamp.csv"

    $Result | Export-Csv $ReportFile -NoTypeInformation -Encoding UTF8

    exit 0
}

Write-Host "Compilation PASSED." -ForegroundColor Green

# ------------------------------------------------------------
# Prepare hidden test
# ------------------------------------------------------------

$HiddenTest = Join-Path $TestsCopy "assignment.test.cjs"

if (-not (Test-Path $HiddenTest)) {

    throw @"
Hidden test file not found.

Expected:
$HiddenTest

Use assignment.test.cjs for trainer-side hidden tests.
"@
}

# ------------------------------------------------------------
# Run hidden tests
# ------------------------------------------------------------

Write-Host ""
Write-Host "Running hidden tests..." -ForegroundColor Cyan
Write-Host ""

$env:SUBMISSION_COMPILED_PATH = $SubmissionCompileOut
$env:HIDDEN_TEST_PATH = $HiddenTest

$TestOutput = & node $TestRunner 2>&1
$TestExitCode = $LASTEXITCODE

$TestOutput | ForEach-Object {
    Write-Host $_
}

# ------------------------------------------------------------
# Parse Node test output
# ------------------------------------------------------------

$Passed = 0
$Failed = 0

$PassedMatch = [regex]::Match(
    ($TestOutput -join "`n"),
    '(\d+)\s+pass'
)

$FailedMatch = [regex]::Match(
    ($TestOutput -join "`n"),
    '(\d+)\s+fail'
)

if ($PassedMatch.Success) {
    $Passed = [int]$PassedMatch.Groups[1].Value
}

if ($FailedMatch.Success) {
    $Failed = [int]$FailedMatch.Groups[1].Value
}

$Total = $Passed + $Failed

if ($Total -gt 0) {
    $Score = [math]::Round(($Passed / $Total) * 100, 2)
}
else {
    $Score = 0
}

if ($TestExitCode -eq 0 -and $Failed -eq 0) {
    $Status = "PASS"
    $Message = "All tests passed"
}
elseif ($Passed -gt 0 -or $Failed -gt 0) {
    $Status = "PARTIAL"
    $Message = "Some tests failed"
}
else {
    $Status = "TEST_ERROR"
    $Message = "Tests could not be executed or no test results were detected"
}

# ------------------------------------------------------------
# Save detailed output
# ------------------------------------------------------------

$OutputFile = Join-Path `
    $ReportsPath `
    "verification-$Technology-$Day-$Assignment-$TraineeId-$ResultTimestamp.txt"

$TestOutput | Out-File `
    $OutputFile `
    -Encoding UTF8

# ------------------------------------------------------------
# Save CSV result
# ------------------------------------------------------------

$Result = [PSCustomObject]@{
    Timestamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    TraineeId    = $TraineeId
    TraineeName  = $TraineeName
    Repository   = $Repository
    Technology   = $Technology
    Day          = $Day
    Assignment   = $Assignment
    Submission   = "FOUND"
    Compilation  = "PASS"
    Passed       = $Passed
    Failed       = $Failed
    Score        = $Score
    Status       = $Status
    Message      = $Message
}

$ReportFile = Join-Path `
    $ReportsPath `
    "verification-$Technology-$Day-$Assignment-$TraineeId-$ResultTimestamp.csv"

$Result | Export-Csv `
    $ReportFile `
    -NoTypeInformation `
    -Encoding UTF8

# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                 VERIFICATION RESULT" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Trainee       : $TraineeId - $TraineeName"
Write-Host "Assignment    : $Technology / $Day / $Assignment"
Write-Host "Submission    : FOUND"
Write-Host "Compilation   : PASS"
Write-Host "Tests Passed  : $Passed"
Write-Host "Tests Failed  : $Failed"
Write-Host "Score         : $Score%"
Write-Host "Status        : $Status"
Write-Host ""
Write-Host "CSV Report    : $ReportFile"
Write-Host "Detail Report : $OutputFile"
Write-Host ""

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

Remove-Item `
    $VerificationRoot `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue

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

# ============================================================
# TRAINEE ASSIGNMENT VERIFICATION
# Robust PowerShell version
# ============================================================

# IMPORTANT:
# Git, tsc and node can write informational/warning messages to
# stderr. Do NOT use ErrorActionPreference = Stop for native
# commands because PowerShell may turn harmless stderr into an
# exception.
$ErrorActionPreference = "Continue"

# PowerShell 7 setting. Windows PowerShell 5.1 does not have this
# variable, so check before assigning it.
if ($null -ne (Get-Variable PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue)) {
    $PSNativeCommandUseErrorActionPreference = $false
}

# ------------------------------------------------------------
# Helper: run a native command safely
# ------------------------------------------------------------
function Invoke-NativeCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $false)]
        [string[]]$Arguments = @(),

        [Parameter(Mandatory = $false)]
        [string]$WorkingDirectory = ""
    )

    $oldLocation = Get-Location

    try {
        if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {
            Set-Location $WorkingDirectory
        }

        # Capture stdout/stderr without allowing native stderr to
        # terminate the script.
        $output = @(& $Command @Arguments 2>&1)
        $exitCode = $LASTEXITCODE

        return [PSCustomObject]@{
            Output   = $output
            ExitCode = $exitCode
        }
    }
    finally {
        Set-Location $oldLocation
    }
}

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

$BasePath = Split-Path -Parent $PSScriptRoot

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
# Helper: save a result and display it
# ------------------------------------------------------------
function Save-VerificationResult {
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Result,

        [Parameter(Mandatory = $true)]
        [string]$ReportsPath,

        [Parameter(Mandatory = $true)]
        [string]$Technology,

        [Parameter(Mandatory = $true)]
        [string]$Day,

        [Parameter(Mandatory = $true)]
        [string]$Assignment,

        [Parameter(Mandatory = $true)]
        [string]$TraineeId,

        [Parameter(Mandatory = $true)]
        [string]$Timestamp
    )

    $ReportFile = Join-Path `
        $ReportsPath `
        "verification-$Technology-$Day-$Assignment-$TraineeId-$Timestamp.csv"

    $Result | Export-Csv `
        $ReportFile `
        -NoTypeInformation `
        -Encoding UTF8

    Write-Host ""
    $Result | Format-List
    Write-Host ""
    Write-Host "CSV Report: $ReportFile" -ForegroundColor Green

    return $ReportFile
}

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

# Support either naming convention:
# assignment.test.cjs OR assignment.test.js
# The preferred trainer-only test file is assignment.test.cjs.
$HiddenTestCjs = Join-Path $HiddenTestsPath "assignment.test.cjs"
$HiddenTestJs  = Join-Path $HiddenTestsPath "assignment.test.js"
$HiddenTestTs  = Join-Path $HiddenTestsPath "assignment.test.ts"

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
# Validate hidden test source before doing repository work
# ------------------------------------------------------------

$HiddenTestSource = $null

if (Test-Path $HiddenTestCjs) {
    $HiddenTestSource = $HiddenTestCjs
}
elseif (Test-Path $HiddenTestJs) {
    $HiddenTestSource = $HiddenTestJs
}
elseif (Test-Path $HiddenTestTs) {
    $HiddenTestSource = $HiddenTestTs
}

if ($null -eq $HiddenTestSource) {
    throw @"
Hidden test file not found.

Expected one of:
$HiddenTestCjs
$HiddenTestJs
$HiddenTestTs

Create the trainer-only hidden test before running verification.
"@
}

# ------------------------------------------------------------
# Pull repository
# ------------------------------------------------------------

if (-not (Test-Path $LocalRepo)) {

    Write-Host "Cloning repository..." -ForegroundColor Gray

    $cloneResult = Invoke-NativeCommand `
        -Command "git" `
        -Arguments @("clone", $RepoUrl, $LocalRepo)

    $cloneResult.Output | ForEach-Object {
        Write-Host $_
    }

    if ($cloneResult.ExitCode -ne 0) {
        throw "Git clone failed for $Repository."
    }
}
else {

    Write-Host "Repository already exists locally."

    $checkoutResult = Invoke-NativeCommand `
        -Command "git" `
        -Arguments @("checkout", $Branch) `
        -WorkingDirectory $LocalRepo

    $checkoutResult.Output | ForEach-Object {
        Write-Host $_
    }

    if ($checkoutResult.ExitCode -ne 0) {
        throw "Unable to checkout $Branch in $Repository."
    }

    $pullResult = Invoke-NativeCommand `
        -Command "git" `
        -Arguments @("pull", "origin", $Branch) `
        -WorkingDirectory $LocalRepo

    $pullResult.Output | ForEach-Object {
        Write-Host $_
    }

    if ($pullResult.ExitCode -ne 0) {
        throw "Git pull failed for $Repository."
    }
}

# ------------------------------------------------------------
# Validate submission
# ------------------------------------------------------------

if (-not (Test-Path $SubmissionPath)) {

    Write-Host ""
    Write-Host "SUBMISSION MISSING" -ForegroundColor Red
    Write-Host "Expected:"
    Write-Host $SubmissionPath

    $Result = [PSCustomObject]@{
        Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TraineeId   = $TraineeId
        TraineeName = $TraineeName
        Repository  = $Repository
        Technology  = $Technology
        Day         = $Day
        Assignment  = $Assignment
        Submission  = "MISSING"
        Compilation = "NOT_RUN"
        Passed      = 0
        Failed      = 0
        Score       = 0
        Status      = "NOT_SUBMITTED"
        Message     = "Submission folder not found"
    }

    Save-VerificationResult `
        -Result $Result `
        -ReportsPath $ReportsPath `
        -Technology $Technology `
        -Day $Day `
        -Assignment $Assignment `
        -TraineeId $TraineeId `
        -Timestamp $ResultTimestamp | Out-Null

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

$SubmissionFiles = @(
    Get-ChildItem `
        -Path $SubmissionCopy `
        -Filter "*.ts" `
        -Recurse `
        -File
)

if ($SubmissionFiles.Count -eq 0) {

    Write-Host "No TypeScript files found in submission." -ForegroundColor Red

    $Result = [PSCustomObject]@{
        Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TraineeId   = $TraineeId
        TraineeName = $TraineeName
        Repository  = $Repository
        Technology  = $Technology
        Day         = $Day
        Assignment  = $Assignment
        Submission  = "FOUND"
        Compilation = "FAILED"
        Passed      = 0
        Failed      = 0
        Score       = 0
        Status      = "COMPILE_ERROR"
        Message     = "No TypeScript files found"
    }

    Save-VerificationResult `
        -Result $Result `
        -ReportsPath $ReportsPath `
        -Technology $Technology `
        -Day $Day `
        -Assignment $Assignment `
        -TraineeId $TraineeId `
        -Timestamp $ResultTimestamp | Out-Null

    exit 0
}

$SubmissionCompileOut = Join-Path $VerificationRoot "submission-compile"

New-Item -ItemType Directory -Force -Path $SubmissionCompileOut | Out-Null

$compileArguments = @(
    "tsc"
)

if ($TscCommandName -ne "npx") {
    $compileArguments = @()
}

$compileArguments += @(
    "--target", "ES2022",
    "--module", "commonjs",
    "--strict",
    "--esModuleInterop",
    "--skipLibCheck",
    "--outDir", $SubmissionCompileOut,
    "--rootDir", $SubmissionCopy
)

foreach ($file in $SubmissionFiles) {
    $compileArguments += $file.FullName
}

$compileResult = Invoke-NativeCommand `
    -Command $TscCommandName `
    -Arguments $compileArguments

$compileResult.Output | ForEach-Object {
    Write-Host $_
}

if ($compileResult.ExitCode -ne 0) {

    Write-Host ""
    Write-Host "COMPILATION FAILED" -ForegroundColor Red

    $compileMessage = ($compileResult.Output -join "`n")

    $Result = [PSCustomObject]@{
        Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        TraineeId   = $TraineeId
        TraineeName = $TraineeName
        Repository  = $Repository
        Technology  = $Technology
        Day         = $Day
        Assignment  = $Assignment
        Submission  = "FOUND"
        Compilation = "FAILED"
        Passed      = 0
        Failed      = 0
        Score       = 0
        Status      = "COMPILE_ERROR"
        Message     = $compileMessage
    }

    Save-VerificationResult `
        -Result $Result `
        -ReportsPath $ReportsPath `
        -Technology $Technology `
        -Day $Day `
        -Assignment $Assignment `
        -TraineeId $TraineeId `
        -Timestamp $ResultTimestamp | Out-Null

    exit 0
}

Write-Host "Compilation PASSED." -ForegroundColor Green

# ------------------------------------------------------------
# Prepare hidden test
# ------------------------------------------------------------

$HiddenTest = $null

$CopiedCjs = Join-Path $TestsCopy "assignment.test.cjs"
$CopiedJs  = Join-Path $TestsCopy "assignment.test.js"
$CopiedTs  = Join-Path $TestsCopy "assignment.test.ts"

if (Test-Path $CopiedCjs) {
    $HiddenTest = $CopiedCjs
}
elseif (Test-Path $CopiedJs) {
    $HiddenTest = $CopiedJs
}
elseif (Test-Path $CopiedTs) {
    $HiddenTest = $CopiedTs
}

if ($null -eq $HiddenTest) {
    throw @"
Hidden test file could not be found after copying.

Expected assignment.test.cjs, assignment.test.js or assignment.test.ts
inside:
$TestsCopy
"@
}

# ------------------------------------------------------------
# TypeScript hidden test handling
# ------------------------------------------------------------

# The preferred hidden test is JavaScript/CommonJS.
# If a TypeScript hidden test is supplied, compile it first.
if ($HiddenTest.ToLower().EndsWith(".ts")) {

    Write-Host ""
    Write-Host "Compiling trainer hidden test..." -ForegroundColor Cyan

    $HiddenTestCompileOut = Join-Path $VerificationRoot "hidden-test-compile"

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $HiddenTestCompileOut | Out-Null

    $hiddenCompileArguments = @()

    if ($TscCommandName -eq "npx") {
        $hiddenCompileArguments += "tsc"
    }

    $hiddenCompileArguments += @(
        "--target", "ES2022",
        "--module", "commonjs",
        "--strict",
        "--esModuleInterop",
        "--skipLibCheck",
        "--outDir", $HiddenTestCompileOut,
        $HiddenTest
    )

    $hiddenCompileResult = Invoke-NativeCommand `
        -Command $TscCommandName `
        -Arguments $hiddenCompileArguments

    $hiddenCompileResult.Output | ForEach-Object {
        Write-Host $_
    }

    if ($hiddenCompileResult.ExitCode -ne 0) {
        throw "Trainer hidden test compilation failed."
    }

    $compiledHiddenTest = Get-ChildItem `
        -Path $HiddenTestCompileOut `
        -Filter "assignment.test.js" `
        -Recurse `
        -File |
        Select-Object -First 1

    if ($null -eq $compiledHiddenTest) {
        throw "Compiled hidden test assignment.test.js was not found."
    }

    $HiddenTest = $compiledHiddenTest.FullName
}

# ------------------------------------------------------------
# Run hidden tests
# ------------------------------------------------------------

Write-Host ""
Write-Host "Running hidden tests..." -ForegroundColor Cyan
Write-Host ""

$env:SUBMISSION_COMPILED_PATH = $SubmissionCompileOut
$env:HIDDEN_TEST_PATH = $HiddenTest

$TestOutput = @(
    & node --test $HiddenTest 2>&1
)

$TestExitCode = $LASTEXITCODE

$TestOutput | ForEach-Object {
    Write-Host $_
}

# ------------------------------------------------------------
# Parse Node test output
# ------------------------------------------------------------

$Passed = 0
$Failed = 0

$AllTestOutput = $TestOutput -join "`n"

# Node's TAP output can contain:
#   # tests 5
#   # pass 4
#   # fail 1
#
# Prefer the summary lines to avoid accidentally counting words
# inside individual test names/messages.
$PassedMatch = [regex]::Match(
    $AllTestOutput,
    '(?m)^\s*#\s+pass\s+(\d+)\s*$'
)

$FailedMatch = [regex]::Match(
    $AllTestOutput,
    '(?m)^\s*#\s+fail\s+(\d+)\s*$'
)

if ($PassedMatch.Success) {
    $Passed = [int]$PassedMatch.Groups[1].Value
}

if ($FailedMatch.Success) {
    $Failed = [int]$FailedMatch.Groups[1].Value
}

# Fallback for alternate output such as "5 pass / 1 fail".
if (-not $PassedMatch.Success) {
    $PassedMatch = [regex]::Match(
        $AllTestOutput,
        '(\d+)\s+pass'
    )

    if ($PassedMatch.Success) {
        $Passed = [int]$PassedMatch.Groups[1].Value
    }
}

if (-not $FailedMatch.Success) {
    $FailedMatch = [regex]::Match(
        $AllTestOutput,
        '(\d+)\s+fail'
    )

    if ($FailedMatch.Success) {
        $Failed = [int]$FailedMatch.Groups[1].Value
    }
}

$Total = $Passed + $Failed

if ($Total -gt 0) {
    $Score = [math]::Round(($Passed / $Total) * 100, 2)
}
else {
    $Score = 0
}

if ($TestExitCode -eq 0 -and $Failed -eq 0 -and $Passed -gt 0) {
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
    Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    TraineeId   = $TraineeId
    TraineeName = $TraineeName
    Repository  = $Repository
    Technology  = $Technology
    Day         = $Day
    Assignment  = $Assignment
    Submission  = "FOUND"
    Compilation = "PASS"
    Passed      = $Passed
    Failed      = $Failed
    Score       = $Score
    Status      = $Status
    Message     = $Message
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
Write-Host "Repository    : $Repository"
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
# Cleanup environment variables
# ------------------------------------------------------------

Remove-Item Env:SUBMISSION_COMPILED_PATH -ErrorAction SilentlyContinue
Remove-Item Env:HIDDEN_TEST_PATH -ErrorAction SilentlyContinue

# ------------------------------------------------------------
# Cleanup temporary verification workspace
# ------------------------------------------------------------

if (Test-Path $VerificationRoot) {
    Remove-Item `
        $VerificationRoot `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue
}

Write-Host "Verification completed." -ForegroundColor Green

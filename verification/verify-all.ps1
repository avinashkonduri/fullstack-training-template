param(
    [Parameter(Mandatory = $true)]
    [string]$Technology,

    [Parameter(Mandatory = $true)]
    [string]$Day,

    [Parameter(Mandatory = $true)]
    [string]$Assignment,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $PSScriptRoot
$BasePath = Split-Path -Parent $ScriptRoot

$TraineesFile = Join-Path $BasePath "trainees.csv"
$WorkPath = Join-Path $BasePath "trainee-work"
$TestsPath = Join-Path $BasePath "tests"
$ReportsPath = Join-Path $BasePath "reports\verification"

$SingleVerifier = Join-Path $ScriptRoot "verify-assignment.ps1"

if (-not (Test-Path $SingleVerifier)) {
    throw "verify-assignment.ps1 not found: $SingleVerifier"
}

if (-not (Test-Path $TraineesFile)) {
    throw "trainees.csv not found: $TraineesFile"
}

$Trainees = @(Import-Csv $TraineesFile)

if ($Trainees.Count -eq 0) {
    throw "No trainees found."
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "             FULL STACK VERIFICATION RUNNER" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Technology : $Technology"
Write-Host "Day        : $Day"
Write-Host "Assignment : $Assignment"
Write-Host "Trainees   : $($Trainees.Count)"

if ($DryRun) {
    Write-Host "Mode       : DRY RUN" -ForegroundColor Yellow
}
else {
    Write-Host "Mode       : LIVE VERIFICATION" -ForegroundColor Green
}

Write-Host ""

$Results = @()

foreach ($Trainee in $Trainees) {

    $TraineeId = $Trainee.TraineeId

    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "Verifying: $TraineeId - $($Trainee.TraineeName)" -ForegroundColor Cyan
    Write-Host "------------------------------------------------------------"

    if ($DryRun) {

        Write-Host "[DRY RUN] Would verify $TraineeId" -ForegroundColor Yellow

        $Results += [PSCustomObject]@{
            Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            TraineeId   = $Trainee.TraineeId
            TraineeName = $Trainee.TraineeName
            Repository  = $Trainee.Repository
            Technology  = $Technology
            Day         = $Day
            Assignment  = $Assignment
            Status      = "DRY_RUN"
            Passed      = 0
            Failed      = 0
            Score       = 0
            Message     = "Would verify submission"
        }

        continue
    }

    try {

        & $SingleVerifier `
            -TraineeId $TraineeId `
            -Technology $Technology `
            -Day $Day `
            -Assignment $Assignment `
            -WorkPath $WorkPath `
            -TestsPath $TestsPath `
            -ReportsPath $ReportsPath

        if ($LASTEXITCODE -ne 0) {
            throw "Verification script returned exit code $LASTEXITCODE."
        }

        $Results += [PSCustomObject]@{
            Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            TraineeId   = $TraineeId
            TraineeName = $Trainee.TraineeName
            Repository  = $Trainee.Repository
            Technology  = $Technology
            Day         = $Day
            Assignment  = $Assignment
            Status      = "COMPLETED"
            Passed      = ""
            Failed      = ""
            Score       = ""
            Message     = "Individual verification completed"
        }
    }
    catch {

        Write-Host "Verification failed for $TraineeId : $($_.Exception.Message)" -ForegroundColor Red

        $Results += [PSCustomObject]@{
            Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            TraineeId   = $TraineeId
            TraineeName = $Trainee.TraineeName
            Repository  = $Trainee.Repository
            Technology  = $Technology
            Day         = $Day
            Assignment  = $Assignment
            Status      = "ERROR"
            Passed      = 0
            Failed      = 0
            Score       = 0
            Message     = $_.Exception.Message
        }
    }
}

New-Item -ItemType Directory -Force -Path $ReportsPath | Out-Null

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$SummaryFile = Join-Path `
    $ReportsPath `
    "verification-summary-$Technology-$Day-$Assignment-$Timestamp.csv"

$Results | Export-Csv `
    $SummaryFile `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "              VERIFICATION RUN COMPLETE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Technology : $Technology"
Write-Host "Day        : $Day"
Write-Host "Assignment : $Assignment"
Write-Host "Trainees   : $($Trainees.Count)"
Write-Host ""
Write-Host "Summary    : $SummaryFile" -ForegroundColor Green
Write-Host ""

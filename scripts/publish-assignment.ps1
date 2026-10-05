# ============================================================
# Full Stack Training - Assignment Publishing Script
# ============================================================
#
# Purpose:
#   Publish a daily assignment to all trainee repositories.
#
# Example:
#   .\publish-assignment.ps1 `
#       -Technology "TypeScript" `
#       -Day "day-01"
#
# Dry Run:
#   .\publish-assignment.ps1 `
#       -Technology "TypeScript" `
#       -Day "day-01" `
#       -DryRun
#
# ============================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$Technology,

    [Parameter(Mandatory = $true)]
    [string]$Day,

    [switch]$DryRun
)

# ============================================================
# CONFIGURATION
# ============================================================

# ============================================================
# CONFIGURATION
# ============================================================

# Project root:
# G:\training\fullstack-training-template
$BasePath = Split-Path -Parent $PSScriptRoot

# Assignments are directly under project root
$AssignmentsPath = $BasePath

# Trainee CSV
$TraineesFile = Join-Path $BasePath "trainees.csv"

# Temporary working directory
$WorkPath = Join-Path $BasePath "trainee-work"

# Reports
$ReportsPath = Join-Path $BasePath "reports"

# GitHub account
$GitHubUser = "avinashkonduri"

# GitHub repository suffix/pattern
$RepositorySuffix = ""

# ============================================================
# CREATE REQUIRED DIRECTORIES
# ============================================================

New-Item -ItemType Directory -Force -Path $WorkPath | Out-Null
New-Item -ItemType Directory -Force -Path $ReportsPath | Out-Null

# ============================================================
# VALIDATE INPUTS
# ============================================================

$AssignmentSource = Join-Path $AssignmentsPath "$Technology\$Day\$Assignment"

$READMEFile = Join-Path $AssignmentSource "README.md"

$StarterFolder = Join-Path $AssignmentSource "starter"

if (-not (Test-Path $TraineesFile)) {

    Write-Host ""
    Write-Host "ERROR: trainees.csv not found." -ForegroundColor Red
    Write-Host "Expected:"
    Write-Host $TraineesFile
    exit 1
}

if (-not (Test-Path $AssignmentSource)) {

    Write-Host ""
    Write-Host "ERROR: Assignment folder not found." -ForegroundColor Red
    Write-Host $AssignmentSource
    exit 1
}

if (-not (Test-Path $READMEFile)) {

    Write-Host ""
    Write-Host "ERROR: README.md not found." -ForegroundColor Red
    Write-Host $READMEFile
    exit 1
}

if (-not (Test-Path $StarterFolder)) {

    Write-Host ""
    Write-Host "ERROR: starter folder not found." -ForegroundColor Red
    Write-Host $StarterFolder
    exit 1
}

# ============================================================
# DISPLAY ASSIGNMENT INFORMATION
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "          FULL STACK ASSIGNMENT PUBLISHER" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Technology : $Technology"
Write-Host "Assignment : $Day"
Write-Host "Source     : $AssignmentSource"

if ($DryRun) {
    Write-Host "Mode       : DRY RUN" -ForegroundColor Yellow
}
else {
    Write-Host "Mode       : LIVE PUBLISH" -ForegroundColor Green
}

Write-Host ""

# ============================================================
# LOAD TRAINEES
# ============================================================

$Trainees = Import-Csv $TraineesFile

if ($Trainees.Count -eq 0) {

    Write-Host "ERROR: No trainees found in CSV." -ForegroundColor Red
    exit 1
}

Write-Host "Trainees found: $($Trainees.Count)" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# CONFIRMATION FOR LIVE MODE
# ============================================================

if (-not $DryRun) {

    Write-Host "You are about to publish:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Technology : $Technology"
    Write-Host "Assignment : $Day"
    Write-Host "Trainees   : $($Trainees.Count)"
    Write-Host ""

    $Confirmation = Read-Host "Type PUBLISH to continue"

    if ($Confirmation -ne "PUBLISH") {

        Write-Host ""
        Write-Host "Publishing cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# ============================================================
# REPORT COLLECTION
# ============================================================

$Results = @()

# ============================================================
# PROCESS EACH TRAINEE
# ============================================================

foreach ($Trainee in $Trainees) {

    $TraineeId = $Trainee.TraineeId
    $TraineeName = $Trainee.TraineeName
    $Repository = $Trainee.Repository

    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "Processing: $TraineeId - $TraineeName" -ForegroundColor Cyan
    Write-Host "Repository: $Repository"
    Write-Host "------------------------------------------------------------"

    # --------------------------------------------------------
    # Validate repository field
    # --------------------------------------------------------

    if ([string]::IsNullOrWhiteSpace($Repository)) {

        Write-Host "FAILED: Repository name missing." -ForegroundColor Red

        $Results += [PSCustomObject]@{
            TraineeId = $TraineeId
            TraineeName = $TraineeName
            Repository = ""
            Technology = $Technology
            Day = $Day
            Status = "FAILED"
            Message = "Repository name missing"
        }

        continue
    }

    # --------------------------------------------------------
    # Repository URL
    # --------------------------------------------------------

    $RepoUrl = "https://github.com/$GitHubUser/$Repository.git"

    # --------------------------------------------------------
    # Local repository path
    # --------------------------------------------------------

    $LocalRepo = Join-Path $WorkPath $Repository

    # --------------------------------------------------------
    # Clone repository if not already cloned
    # --------------------------------------------------------

    try {

        if (-not (Test-Path $LocalRepo)) {

            Write-Host "Cloning repository..." -ForegroundColor Gray

            if ($DryRun) {

                Write-Host "[DRY RUN] Would clone $RepoUrl" -ForegroundColor Yellow

            }
            else {

                git clone $RepoUrl $LocalRepo

                if ($LASTEXITCODE -ne 0) {
                    throw "Git clone failed."
                }
            }
        }
        else {

            Write-Host "Repository already exists locally."

            if (-not $DryRun) {

                Push-Location $LocalRepo

                git checkout main 2>$null
                git pull origin main

                if ($LASTEXITCODE -ne 0) {
                    throw "Git pull failed."
                }

                Pop-Location
            }
        }

        # ----------------------------------------------------
        # Destination
        # ----------------------------------------------------

        $Destination = Join-Path `
            $LocalRepo `
            "TypeScript\$Day"

        # ----------------------------------------------------
        # Create destination directories
        # ----------------------------------------------------

        if ($DryRun) {

            Write-Host ""
            Write-Host "[DRY RUN] Would create:" -ForegroundColor Yellow

            Write-Host "  $Destination"
            Write-Host "  $Destination\starter"
            Write-Host "  $Destination\submission"
        }
        else {

            New-Item `
                -ItemType Directory `
                -Force `
                -Path $Destination | Out-Null

            $DestinationStarter = Join-Path `
                $Destination `
                "starter"

            $DestinationSubmission = Join-Path `
                $Destination `
                "submission"

            New-Item `
                -ItemType Directory `
                -Force `
                -Path $DestinationStarter | Out-Null

            New-Item `
                -ItemType Directory `
                -Force `
                -Path $DestinationSubmission | Out-Null

            # ------------------------------------------------
            # Copy README
            # ------------------------------------------------

            Copy-Item `
                $READMEFile `
                $Destination `
                -Force

            # ------------------------------------------------
            # Copy starter files
            # ------------------------------------------------

            Copy-Item `
                "$StarterFolder\*" `
                $DestinationStarter `
                -Recurse `
                -Force

            # ------------------------------------------------
            # Create .gitkeep
            # ------------------------------------------------

            $GitKeepFile = Join-Path `
                $DestinationSubmission `
                ".gitkeep"

            if (-not (Test-Path $GitKeepFile)) {

                New-Item `
                    -ItemType File `
                    -Path $GitKeepFile `
                    -Force | Out-Null
            }

            Write-Host ""
            Write-Host "Assignment copied successfully." -ForegroundColor Green
        }

        # ----------------------------------------------------
        # Git operations
        # ----------------------------------------------------

        if (-not $DryRun) {

            Push-Location $LocalRepo

            Write-Host "Checking Git status..."

            git status --short

            # ------------------------------------------------
            # Add only the assignment
            # ------------------------------------------------

            git add "TypeScript/$Day"

            if ($LASTEXITCODE -ne 0) {
                throw "git add failed."
            }

            # ------------------------------------------------
            # Check whether there is anything to commit
            # ------------------------------------------------

            git diff --cached --quiet

            if ($LASTEXITCODE -eq 0) {

                Write-Host "No changes to commit." -ForegroundColor Yellow

                Pop-Location

                $Results += [PSCustomObject]@{
                    TraineeId = $TraineeId
                    TraineeName = $TraineeName
                    Repository = $Repository
                    Technology = $Technology
                    Day = $Day
                    Status = "ALREADY_PUBLISHED"
                    Message = "No changes"
                }

                continue
            }

            # ------------------------------------------------
            # Commit
            # ------------------------------------------------

            $CommitMessage = "Publish $Technology $Day assignment"

            git commit -m $CommitMessage

            if ($LASTEXITCODE -ne 0) {
                throw "git commit failed."
            }

            # ------------------------------------------------
            # Push
            # ------------------------------------------------

            Write-Host "Pushing assignment..."

            git push origin main

            if ($LASTEXITCODE -ne 0) {
                throw "git push failed."
            }

            Pop-Location

            Write-Host ""
            Write-Host "SUCCESS: Assignment published." -ForegroundColor Green

            $Results += [PSCustomObject]@{
                TraineeId = $TraineeId
                TraineeName = $TraineeName
                Repository = $Repository
                Technology = $Technology
                Day = $Day
                Status = "SUCCESS"
                Message = "Assignment published successfully"
            }
        }
        else {

            Write-Host ""
            Write-Host "[DRY RUN] No Git changes were made." -ForegroundColor Yellow

            $Results += [PSCustomObject]@{
                TraineeId = $TraineeId
                TraineeName = $TraineeName
                Repository = $Repository
                Technology = $Technology
                Day = $Day
                Status = "DRY_RUN"
                Message = "Would publish assignment"
            }
        }

    }
    catch {

        if ($PWD.Path -eq $LocalRepo) {
            Pop-Location
        }

        Write-Host ""
        Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red

        $Results += [PSCustomObject]@{
            TraineeId = $TraineeId
            TraineeName = $TraineeName
            Repository = $Repository
            Technology = $Technology
            Day = $Day
            Status = "FAILED"
            Message = $_.Exception.Message
        }
    }
}

# ============================================================
# GENERATE REPORT
# ============================================================

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportFile = Join-Path `
    $ReportsPath `
    "assignment-publishing-$Technology-$Day-$Timestamp.csv"

$Results | Export-Csv `
    $ReportFile `
    -NoTypeInformation `
    -Encoding UTF8

# ============================================================
# SUMMARY
# ============================================================

$SuccessCount = @(
    $Results | Where-Object { $_.Status -eq "SUCCESS" }
).Count

$FailedCount = @(
    $Results | Where-Object { $_.Status -eq "FAILED" }
).Count

$AlreadyPublishedCount = @(
    $Results | Where-Object { $_.Status -eq "ALREADY_PUBLISHED" }
).Count

$DryRunCount = @(
    $Results | Where-Object { $_.Status -eq "DRY_RUN" }
).Count

Write-Host ""
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                 PUBLISHING SUMMARY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Technology       : $Technology"
Write-Host "Assignment       : $Day"
Write-Host "Total Trainees   : $($Results.Count)"

if ($DryRun) {
    Write-Host "Dry Run          : $DryRunCount" -ForegroundColor Yellow
}
else {
    Write-Host "Successful       : $SuccessCount" -ForegroundColor Green
    Write-Host "Already Published: $AlreadyPublishedCount" -ForegroundColor Yellow
    Write-Host "Failed           : $FailedCount" -ForegroundColor Red
}

Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportFile
Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
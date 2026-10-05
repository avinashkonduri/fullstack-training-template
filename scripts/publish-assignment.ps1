# ============================================================
# Full Stack Training - Assignment Publishing Script
# ============================================================
#
# Purpose:
#   Publish a specific assignment to all trainee repositories.
#
# Project structure:
#
#   G:\training\fullstack-training-template\
#   ├── TypeScript\
#   │   └── day-01\
#   │       ├── assignment-01\
#   │       │   ├── README.md
#   │       │   └── starter\
#   │       ├── assignment-02\
#   │       │   ├── README.md
#   │       │   └── starter\
#   │       └── ...
#   ├── trainees.csv
#   ├── trainee-work\
#   ├── reports\
#   └── scripts\
#       └── publish-assignment.ps1
#
# Student repository structure:
#
#   TypeScript\
#   └── day-01\
#       └── assignment-02\
#           ├── README.md
#           ├── starter\
#           └── submission\
#
# Examples:
#
#   .\publish-assignment.ps1 `
#       -Technology "TypeScript" `
#       -Day "day-01" `
#       -Assignment "assignment-02"
#
# Dry Run:
#
#   .\publish-assignment.ps1 `
#       -Technology "TypeScript" `
#       -Day "day-01" `
#       -Assignment "assignment-02" `
#       -DryRun
#
# ============================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$Technology,

    [Parameter(Mandatory = $true)]
    [string]$Day,

    [Parameter(Mandatory = $true)]
    [string]$Assignment,

    [switch]$DryRun
)

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

# Branch
$GitBranch = "main"

# ============================================================
# ASSIGNMENT SOURCE
# ============================================================

$AssignmentSource = Join-Path `
    $AssignmentsPath `
    "$Technology\$Day\$Assignment"

$READMEFile = Join-Path `
    $AssignmentSource `
    "README.md"

$StarterFolder = Join-Path `
    $AssignmentSource `
    "starter"

# ============================================================
# CREATE REQUIRED DIRECTORIES
# ============================================================

New-Item -ItemType Directory -Force -Path $WorkPath | Out-Null
New-Item -ItemType Directory -Force -Path $ReportsPath | Out-Null

# ============================================================
# VALIDATE INPUTS
# ============================================================

if ([string]::IsNullOrWhiteSpace($Technology)) {
    Write-Host "ERROR: Technology is required." -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Day)) {
    Write-Host "ERROR: Day is required." -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Assignment)) {
    Write-Host "ERROR: Assignment is required." -ForegroundColor Red
    exit 1
}

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
    Write-Host ""
    Write-Host "Expected structure:"
    Write-Host "$Technology\$Day\$Assignment\README.md"
    Write-Host "$Technology\$Day\$Assignment\starter\"
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
Write-Host "             FULL STACK ASSIGNMENT PUBLISHER" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Technology : $Technology"
Write-Host "Day        : $Day"
Write-Host "Assignment : $Assignment"
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

$Trainees = @(Import-Csv $TraineesFile)

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
    Write-Host "Day        : $Day"
    Write-Host "Assignment : $Assignment"
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
    # Validate trainee fields
    # --------------------------------------------------------

    if ([string]::IsNullOrWhiteSpace($TraineeId)) {

        Write-Host "FAILED: Trainee ID missing." -ForegroundColor Red

        $Results += [PSCustomObject]@{
            TraineeId   = ""
            TraineeName = $TraineeName
            Repository  = $Repository
            Technology   = $Technology
            Day          = $Day
            Assignment   = $Assignment
            Status       = "FAILED"
            Message      = "Trainee ID missing"
        }

        continue
    }

    if ([string]::IsNullOrWhiteSpace($Repository)) {

        Write-Host "FAILED: Repository name missing." -ForegroundColor Red

        $Results += [PSCustomObject]@{
            TraineeId   = $TraineeId
            TraineeName = $TraineeName
            Repository  = ""
            Technology   = $Technology
            Day          = $Day
            Assignment   = $Assignment
            Status       = "FAILED"
            Message      = "Repository name missing"
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

    try {

        # ----------------------------------------------------
        # Clone repository if not already cloned
        # ----------------------------------------------------

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

                try {

                    git checkout $GitBranch 2>$null

                    if ($LASTEXITCODE -ne 0) {
                        throw "Unable to checkout branch '$GitBranch'."
                    }

                    git pull origin $GitBranch

                    if ($LASTEXITCODE -ne 0) {
                        throw "Git pull failed."
                    }

                }
                finally {
                    Pop-Location
                }
            }
        }

        # ----------------------------------------------------
        # Destination
        # ----------------------------------------------------

        $Destination = Join-Path `
            $LocalRepo `
            "$Technology\$Day\$Assignment"

        $DestinationStarter = Join-Path `
            $Destination `
            "starter"

        $DestinationSubmission = Join-Path `
            $Destination `
            "submission"

        # ----------------------------------------------------
        # Dry Run
        # ----------------------------------------------------

        if ($DryRun) {

            Write-Host ""
            Write-Host "[DRY RUN] Would create:" -ForegroundColor Yellow
            Write-Host "  $Destination"
            Write-Host "  $DestinationStarter"
            Write-Host "  $DestinationSubmission"

            Write-Host ""
            Write-Host "[DRY RUN] Would copy:" -ForegroundColor Yellow
            Write-Host "  $READMEFile"
            Write-Host "  $StarterFolder\*"

            Write-Host ""
            Write-Host "[DRY RUN] Would commit:" -ForegroundColor Yellow
            Write-Host "  Publish $Technology $Day $Assignment"

            Write-Host ""
            Write-Host "[DRY RUN] Would push to:" -ForegroundColor Yellow
            Write-Host "  origin/$GitBranch"

            $Results += [PSCustomObject]@{
                TraineeId   = $TraineeId
                TraineeName = $TraineeName
                Repository  = $Repository
                Technology   = $Technology
                Day          = $Day
                Assignment   = $Assignment
                Status       = "DRY_RUN"
                Message      = "Would publish assignment"
            }

            continue
        }

        # ----------------------------------------------------
        # Create destination directories
        # ----------------------------------------------------

        New-Item `
            -ItemType Directory `
            -Force `
            -Path $Destination | Out-Null

        New-Item `
            -ItemType Directory `
            -Force `
            -Path $DestinationStarter | Out-Null

        New-Item `
            -ItemType Directory `
            -Force `
            -Path $DestinationSubmission | Out-Null

        # ----------------------------------------------------
        # Copy README
        # ----------------------------------------------------

        Copy-Item `
            $READMEFile `
            $Destination `
            -Force

        # ----------------------------------------------------
        # Copy starter files
        # ----------------------------------------------------

        $StarterItems = Get-ChildItem `
            -Path $StarterFolder `
            -Force

        foreach ($StarterItem in $StarterItems) {

            Copy-Item `
                $StarterItem.FullName `
                $DestinationStarter `
                -Recurse `
                -Force
        }

        # ----------------------------------------------------
        # Create .gitkeep
        # ----------------------------------------------------

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

        # ----------------------------------------------------
        # Git operations
        # ----------------------------------------------------

        Push-Location $LocalRepo

        try {

            Write-Host "Checking Git status..."

            git status --short

            # ------------------------------------------------
            # Add only this assignment
            # ------------------------------------------------

            $GitPath = "$Technology/$Day/$Assignment"

            git add -- $GitPath

            if ($LASTEXITCODE -ne 0) {
                throw "git add failed."
            }

            # ------------------------------------------------
            # Check whether there is anything to commit
            # ------------------------------------------------

            git diff --cached --quiet

            if ($LASTEXITCODE -eq 0) {

                Write-Host "No changes to commit." -ForegroundColor Yellow

                $Results += [PSCustomObject]@{
                    TraineeId   = $TraineeId
                    TraineeName = $TraineeName
                    Repository  = $Repository
                    Technology   = $Technology
                    Day          = $Day
                    Assignment   = $Assignment
                    Status       = "ALREADY_PUBLISHED"
                    Message      = "No changes"
                }

                continue
            }

            # ------------------------------------------------
            # Commit
            # ------------------------------------------------

            $CommitMessage = "Publish $Technology $Day $Assignment"

            git commit -m $CommitMessage

            if ($LASTEXITCODE -ne 0) {
                throw "git commit failed."
            }

            # ------------------------------------------------
            # Push
            # ------------------------------------------------

            Write-Host "Pushing assignment..."

            git push origin $GitBranch

            if ($LASTEXITCODE -ne 0) {
                throw "git push failed."
            }

        }
        finally {
            Pop-Location
        }

        Write-Host ""
        Write-Host "SUCCESS: Assignment published." -ForegroundColor Green

        $Results += [PSCustomObject]@{
            TraineeId   = $TraineeId
            TraineeName = $TraineeName
            Repository  = $Repository
            Technology   = $Technology
            Day          = $Day
            Assignment   = $Assignment
            Status       = "SUCCESS"
            Message      = "Assignment published successfully"
        }

    }
    catch {

        Write-Host ""

        # Make sure we return to the script directory if an error
        # occurred while inside the trainee repository.
        try {
            if ((Get-Location).Path -eq $LocalRepo) {
                Pop-Location
            }
        }
        catch {
            # Ignore location cleanup errors.
        }

        Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red

        $Results += [PSCustomObject]@{
            TraineeId   = $TraineeId
            TraineeName = $TraineeName
            Repository  = $Repository
            Technology   = $Technology
            Day          = $Day
            Assignment   = $Assignment
            Status       = "FAILED"
            Message      = $_.Exception.Message
        }
    }
}

# ============================================================
# GENERATE REPORT
# ============================================================

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$ReportFile = Join-Path `
    $ReportsPath `
    "assignment-publishing-$Technology-$Day-$Assignment-$Timestamp.csv"

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
Write-Host "Day              : $Day"
Write-Host "Assignment       : $Assignment"
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

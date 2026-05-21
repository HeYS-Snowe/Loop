param(
    [ValidateSet("debug", "release", "profile")]
    [string]$BuildType = "release",
    
    [ValidateSet("release", "beta", "alpha", "rc", "fix", "hotfix", "feature", "dev", "debug")]
    [string]$Status = "release"
)

$ErrorActionPreference = "Stop"

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
$pubspecPath = Join-Path $projectRoot "pubspec.yaml"

function Get-VersionFromPubspec {
    param([string]$pubspecPath)
    
    if (-not (Test-Path $pubspecPath)) {
        Write-Error "pubspec.yaml not found: $pubspecPath"
        exit 1
    }
    
    $content = Get-Content $pubspecPath -Raw
    if ($content -match "version:\s*(\d+\.\d+\.\d+)\+(\d+)") {
        return @{
            Version = $matches[1]
            BuildNumber = [int]$matches[2]
        }
    }
    
    Write-Error "Cannot read version from pubspec.yaml"
    exit 1
}

function Update-VersionInPubspec {
    param(
        [string]$pubspecPath,
        [string]$newVersion,
        [int]$newBuildNumber
    )
    
    $content = Get-Content $pubspecPath -Raw -Encoding UTF8
    $newContent = $content -replace "version:\s*\d+\.\d+\.\d+\+\d+", "version: $newVersion+$newBuildNumber"
    
    [System.IO.File]::WriteAllText($pubspecPath, $newContent, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[VERSION] Updated: $newVersion+$newBuildNumber" -ForegroundColor Yellow
}

function Get-IncrementedVersion {
    param(
        [string]$currentVersion,
        [string]$status
    )
    
    $parts = $currentVersion.Split('.')
    $major = [int]$parts[0]
    $minor = [int]$parts[1]
    $patch = [int]$parts[2]
    
    switch ($status) {
        "release" {
            $minor++
            $patch = 0
        }
        default {
            $patch++
        }
    }
    
    return "$major.$minor.$patch"
}

function Get-BuildDate {
    return Get-Date -Format "yyyyMMdd"
}

function Get-BuildSequence {
    param([string]$buildsDir, [string]$buildDate, [string]$status, [string]$version)
    
    if (-not (Test-Path $buildsDir)) {
        return 1
    }

    $pattern = "Loop_${status}_${version}_${buildDate}_\d{2}\.apk"
    $existingFiles = Get-ChildItem -Path $buildsDir -Filter "*.apk" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $pattern }
    
    if ($existingFiles.Count -eq 0) {
        return 1
    }
    
    $maxSequence = 0
    foreach ($file in $existingFiles) {
        if ($file.Name -match "Loop_${status}_${version}_${buildDate}_(\d{2})\.apk") {
            $sequence = [int]$matches[1]
            if ($sequence -gt $maxSequence) {
                $maxSequence = $sequence
            }
        }
    }
    
    return $maxSequence + 1
}

function Backup-OriginalAPK {
    param([string]$apkPath)
    
    $backupDir = Join-Path (Split-Path $apkPath) "backup"
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupName = "app_$(Split-Path $apkPath -Leaf)_$timestamp.apk"
    $backupPath = Join-Path $backupDir $backupName
    
    Write-Host "[BACKUP] $(Split-Path $apkPath -Leaf) -> backup\$backupName" -ForegroundColor Yellow
    Copy-Item -Path $apkPath -Destination $backupPath -Force
}

function Rename-APK {
    param(
        [string]$apkPath,
        [string]$status,
        [string]$version,
        [string]$buildDate,
        [int]$sequence
    )
    
    $sequenceStr = $sequence.ToString("00")
    $newName = "Loop_${status}_${version}_${buildDate}_${sequenceStr}.apk"
    $newPath = Join-Path (Split-Path $apkPath) $newName
    
    if (Test-Path $newPath) {
        Write-Warning "Target already exists: $newPath"
        return $false
    }
    
    Write-Host "[RENAME] $(Split-Path $apkPath -Leaf) -> $newName" -ForegroundColor Green
    Rename-Item -Path $apkPath -NewName $newName -Force
    return $true
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Loop APK Build Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$versionInfo = Get-VersionFromPubspec -pubspecPath $pubspecPath
$Version = $versionInfo.Version
$BuildNumber = $versionInfo.BuildNumber
$buildDate = Get-BuildDate
$apkOutputDir = Join-Path $projectRoot "build\app\outputs\flutter-apk"

$solutionRoot = Split-Path -Parent $projectRoot
$buildsDir = Join-Path $solutionRoot "builds"
if (-not (Test-Path $buildsDir)) {
    New-Item -ItemType Directory -Path $buildsDir | Out-Null
}

Write-Host "Project:" -ForegroundColor Cyan
Write-Host "  Root:    $projectRoot" -ForegroundColor Gray
Write-Host "  Pubspec: $pubspecPath" -ForegroundColor Gray
Write-Host "  Output:  $apkOutputDir" -ForegroundColor Gray
Write-Host ""

Write-Host "Build Params:" -ForegroundColor Cyan
Write-Host "  BuildType: $BuildType" -ForegroundColor Gray
Write-Host "  Status:    $Status" -ForegroundColor Gray
Write-Host ""

$releaseVersion = Get-IncrementedVersion -currentVersion $Version -status $Status
$releaseBuildNumber = $BuildNumber + 1

Write-Host "Version:" -ForegroundColor Cyan
Write-Host "  Current: $Version+$BuildNumber" -ForegroundColor Gray
Write-Host "  Release: $releaseVersion+$releaseBuildNumber" -ForegroundColor Gray
Write-Host ""

Update-VersionInPubspec -pubspecPath $pubspecPath -newVersion $releaseVersion -newBuildNumber $releaseBuildNumber

$buildSequence = Get-BuildSequence -buildsDir $buildsDir -buildDate $buildDate -status $Status -version $releaseVersion

Write-Host "Build Info:" -ForegroundColor Cyan
Write-Host "  Date:     $buildDate" -ForegroundColor Gray
Write-Host "  Sequence: $($buildSequence.ToString('00'))" -ForegroundColor Gray
Write-Host ""

Write-Host "Building..." -ForegroundColor Green
Set-Location $projectRoot
& flutter build apk --$BuildType

if ($LASTEXITCODE -ne 0) {
    Update-VersionInPubspec -pubspecPath $pubspecPath -newVersion $Version -newBuildNumber $BuildNumber
    Write-Error "Build failed! Version rolled back to $Version+$BuildNumber"
    exit 1
}

Write-Host ""
Write-Host "Build complete, processing APK..." -ForegroundColor Green

$apkFile = Join-Path $apkOutputDir "app-$BuildType.apk"

if (-not (Test-Path $apkFile)) {
    Write-Error "APK not found: $apkFile"
    exit 1
}

Write-Host "Found APK: $apkFile" -ForegroundColor Cyan
Write-Host ""

Backup-OriginalAPK -apkPath $apkFile

if (Rename-APK -apkPath $apkFile -status $Status -version $releaseVersion -buildDate $buildDate -sequence $buildSequence) {
    $newApkName = "Loop_${Status}_${releaseVersion}_${buildDate}_$($buildSequence.ToString('00')).apk"
    $newApkPath = Join-Path $apkOutputDir $newApkName
    $buildsApkPath = Join-Path $buildsDir $newApkName
    
    Copy-Item -Path $newApkPath -Destination $buildsApkPath -Force
    Write-Host "[ARCHIVE] Copied to builds: $newApkName" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Build & Rename Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK:" -ForegroundColor Green
    Write-Host "  $buildsApkPath" -ForegroundColor White
    Write-Host ""
    Write-Host "File Info:" -ForegroundColor Green
    $fileInfo = Get-Item $buildsApkPath
    Write-Host "  Size:      $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor Gray
    Write-Host "  Created:   $($fileInfo.CreationTime)" -ForegroundColor Gray
    Write-Host "  Version:   $releaseVersion (build $releaseBuildNumber)" -ForegroundColor Gray
    Write-Host "  Sequence:  $($buildSequence.ToString('00'))" -ForegroundColor Gray
    
    Write-Host "========================================" -ForegroundColor Cyan
} else {
    Write-Error "Rename failed!"
    exit 1
}

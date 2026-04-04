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
        Write-Error "pubspec.yaml 文件不存在: $pubspecPath"
        exit 1
    }
    
    $content = Get-Content $pubspecPath -Raw
    if ($content -match "version:\s*(\d+\.\d+\.\d+)\+(\d+)") {
        return @{
            Version = $matches[1]
            BuildNumber = [int]$matches[2]
        }
    }
    
    Write-Error "无法从 pubspec.yaml 中读取版本号"
    exit 1
}

function Update-VersionInPubspec {
    param(
        [string]$pubspecPath,
        [string]$newVersion,
        [int]$newBuildNumber
    )
    
    $content = Get-Content $pubspecPath -Raw
    $newContent = $content -replace "version:\s*\d+\.\d+\.\d+\+\d+", "version: $newVersion+$newBuildNumber"
    
    Set-Content -Path $pubspecPath -Value $newContent -NoNewline
    Write-Host "版本号已更新: $newVersion+$newBuildNumber" -ForegroundColor Yellow
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
        "alpha" {
            $patch++
        }
        "beta" {
            $patch++
        }
        "rc" {
            $patch++
        }
        "fix" {
            $patch++
        }
        "hotfix" {
            $patch++
        }
        "feature" {
            $patch++
        }
        "dev" {
            $patch++
        }
        "debug" {
            $patch++
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
    param([string]$apkOutputDir, [string]$buildDate, [string]$status, [string]$version)
    
    $pattern = "Loop_${status}_${version}_${buildDate}_\d{2}\.apk"
    $existingFiles = Get-ChildItem -Path $apkOutputDir -Filter "*.apk" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "Loop_${status}_${version}_${buildDate}_\d{2}\.apk" }
    
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
    
    Write-Host "备份: $(Split-Path $apkPath -Leaf) -> backup\$backupName" -ForegroundColor Yellow
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
        Write-Warning "目标文件已存在: $newPath"
        return $false
    }
    
    Write-Host "重命名: $(Split-Path $apkPath -Leaf) -> $newName" -ForegroundColor Green
    Rename-Item -Path $apkPath -NewName $newName -Force
    return $true
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Loop APK 构建工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$versionInfo = Get-VersionFromPubspec -pubspecPath $pubspecPath
$Version = $versionInfo.Version
$BuildNumber = $versionInfo.BuildNumber
$buildDate = Get-BuildDate
$apkOutputDir = Join-Path $projectRoot "build\app\outputs\flutter-apk"

Write-Host "项目信息:" -ForegroundColor Cyan
Write-Host "  项目根目录: $projectRoot" -ForegroundColor Gray
Write-Host "  pubspec: $pubspecPath" -ForegroundColor Gray
Write-Host "  输出目录: $apkOutputDir" -ForegroundColor Gray
Write-Host ""

Write-Host "构建参数:" -ForegroundColor Cyan
Write-Host "  构建类型: $BuildType" -ForegroundColor Gray
Write-Host "  状态类型: $Status" -ForegroundColor Gray
Write-Host ""

$newVersion = Get-IncrementedVersion -currentVersion $Version -status $Status
$newBuildNumber = $BuildNumber + 1

Write-Host "版本信息:" -ForegroundColor Cyan
Write-Host "  旧版本: $Version+$BuildNumber" -ForegroundColor Gray
Write-Host "  新版本: $newVersion+$newBuildNumber" -ForegroundColor Gray
Write-Host ""

$buildSequence = Get-BuildSequence -apkOutputDir $apkOutputDir -buildDate $buildDate -status $Status -version $Version

Write-Host "构建信息:" -ForegroundColor Cyan
Write-Host "  构建日期: $buildDate" -ForegroundColor Gray
Write-Host "  构建序号: $($buildSequence.ToString('00'))" -ForegroundColor Gray
Write-Host ""

Write-Host "开始构建..." -ForegroundColor Green
Set-Location $projectRoot
& flutter build apk --$BuildType

if ($LASTEXITCODE -ne 0) {
    Write-Error "构建失败！"
    exit 1
}

Write-Host ""
Write-Host "构建完成，开始处理APK文件..." -ForegroundColor Green

$apkFile = Join-Path $apkOutputDir "app-$BuildType.apk"

if (-not (Test-Path $apkFile)) {
    Write-Error "APK 文件不存在: $apkFile"
    exit 1
}

Write-Host "找到 APK 文件: $apkFile" -ForegroundColor Cyan
Write-Host ""

Backup-OriginalAPK -apkPath $apkFile

if (Rename-APK -apkPath $apkFile -status $Status -version $Version -buildDate $buildDate -sequence $buildSequence) {
    $newApkName = "Loop_${Status}_${Version}_${buildDate}_$($buildSequence.ToString('00')).apk"
    $newApkPath = Join-Path $apkOutputDir $newApkName
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "构建和重命名完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK 文件:" -ForegroundColor Green
    Write-Host "  $newApkPath" -ForegroundColor White
    Write-Host ""
    Write-Host "文件信息:" -ForegroundColor Green
    $fileInfo = Get-Item $newApkPath
    Write-Host "  文件大小: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor Gray
    Write-Host "  创建时间: $($fileInfo.CreationTime)" -ForegroundColor Gray
    
    Update-VersionInPubspec -pubspecPath $pubspecPath -newVersion $newVersion -newBuildNumber $newBuildNumber
    
    Write-Host "========================================" -ForegroundColor Cyan
} else {
    Write-Error "重命名失败！"
    exit 1
}

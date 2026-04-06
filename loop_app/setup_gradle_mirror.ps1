$initDir = "$env:USERPROFILE\.gradle\init.d"
if (-not (Test-Path $initDir)) {
    New-Item -ItemType Directory -Path $initDir -Force | Out-Null
}

$content = @"
fun RepositoryHandler.aliyunMirrors() {
    maven { url = uri("https://maven.aliyun.com/repository/google") }
    maven { url = uri("https://maven.aliyun.com/repository/central") }
    maven { url = uri("https://maven.aliyun.com/repository/public") }
    maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
    maven { url = uri("https://maven.aliyun.com/repository/jcenter") }
}

settingsEvaluated {
    pluginManagement {
        repositories { aliyunMirrors() }
    }
}

allprojects {
    repositories { aliyunMirrors() }
}
"@

$targetFile = Join-Path $initDir "china-mirrors.init.gradle.kts"
Set-Content -Path $targetFile -Value $content -Encoding UTF8
Write-Host "Gradle mirror config created: $targetFile"

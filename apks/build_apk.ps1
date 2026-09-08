# Set up portable environment variables
$env:JAVA_HOME = "C:\Users\RemoLaptop15\flutter_env\jdk"
$env:ANDROID_HOME = "C:\Users\RemoLaptop15\flutter_env\android-sdk"
$env:PATH = "C:\Users\RemoLaptop15\flutter_env\flutter\bin;C:\Users\RemoLaptop15\flutter_env\jdk\bin;C:\Users\RemoLaptop15\flutter_env\android-sdk\cmdline-tools\latest\bin;C:\Users\RemoLaptop15\flutter_env\android-sdk\platform-tools;$env:PATH"

# Resolve project root relative to script location
$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}
$ProjectRoot = Split-Path -Parent $ScriptDir

Write-Host "Changing directory to project root: $ProjectRoot"
Push-Location $ProjectRoot

Write-Host "Cleaning build cache..."
flutter clean

Write-Host "Fetching packages..."
flutter pub get

Write-Host "Compiling new Debug APK..."
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host "Copying new APK to script directory..." -ForegroundColor Cyan
    Copy-Item -Path "build\app\outputs\flutter-apk\app-debug.apk" -Destination "$ScriptDir\toothy_c_o_debug.apk" -Force
    Write-Host "Success! New APK ready at: $ScriptDir\toothy_c_o_debug.apk" -ForegroundColor Green
} else {
    Write-Host "Build failed! Please check logs above." -ForegroundColor Red
}

Pop-Location

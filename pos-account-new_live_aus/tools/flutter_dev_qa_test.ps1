Write-Host "========================================="
Write-Host "      Flutter Development QA Test"
Write-Host "========================================="
Write-Host ""

function Test-Command {
    param(
        [string]$Name,
        [string]$Command
    )

    Write-Host "Checking $Name..."

    try {
        $result = Invoke-Expression $Command 2>&1

        if ($LASTEXITCODE -eq 0 -or $result) {
            Write-Host "[PASS] $Name"
            $result | Select-Object -First 5
        }
        else {
            Write-Host "[FAIL] $Name"
        }
    }
    catch {
        Write-Host "[FAIL] $Name"
    }

    Write-Host ""
}

Write-Host "========== SYSTEM =========="

Test-Command "Windows Version" "systeminfo | findstr /B /C:`"OS Name`" /C:`"OS Version`""

Test-Command "Git" "git --version"

Test-Command "Flutter" "flutter --version"

Test-Command "Dart" "dart --version"

Test-Command "Java" "java -version"

Test-Command "ADB" "adb version"

Test-Command "VS Code" "code --version"

Write-Host "========== PATH =========="

$paths = @(
    "C:\src\flutter",
    "D:\flutter",
    "$env:LOCALAPPDATA\Android\Sdk",
    "C:\Program Files\Android\Android Studio"
)

foreach($p in $paths){

    if(Test-Path $p){
        Write-Host "[PASS] $p"
    }
    else{
        Write-Host "[FAIL] $p"
    }

}

Write-Host ""

Write-Host "========== ENVIRONMENT VARIABLES =========="

$envs = @(
    "JAVA_HOME",
    "ANDROID_HOME",
    "ANDROID_SDK_ROOT"
)

foreach($e in $envs){

    $val = [Environment]::GetEnvironmentVariable($e)
    if ($val) {
        Write-Host "[PASS] $e = $val"
    }
    else {
        Write-Host "[FAIL] $e"
    }

}

Write-Host ""

Write-Host "========== FLUTTER DOCTOR =========="

try{
    flutter doctor -v
}
catch{
    Write-Host "[FAIL] Flutter Doctor"
}

Write-Host ""

Write-Host "========== GIT =========="

try{

git status

git branch

git remote -v

}
catch{
    Write-Host "Git repository not initialized."

}

Write-Host ""

Write-Host "========== AI TOOLS =========="

$extensions = @(
"dart-code.flutter",
"dart-code.dart-code",
"github.copilot",
"github.copilot-chat",
"saoudrizwan.claude-dev",
"eamodio.gitlens"
)

foreach($id in $extensions){
    $installed = code --list-extensions | Select-String $id

    if($installed){
        Write-Host "[PASS] $id"
    }
    else{
        Write-Host "[FAIL] $id"
    }

}

Write-Host ""

Write-Host "========== SUMMARY =========="

Write-Host "QA Test Completed."

Write-Host ""

Write-Host "If Flutter, Dart, or ADB fail:"
Write-Host " - Install Flutter SDK"
Write-Host " - Install Android SDK Platform Tools"
Write-Host " - Add Flutter/bin and Android SDK/platform-tools to PATH" 

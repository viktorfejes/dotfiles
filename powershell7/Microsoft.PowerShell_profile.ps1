oh-my-posh init pwsh --config 'C:\Users\vikto\AppData\Local\Programs\oh-my-posh\themes\amro.omp.json' | Invoke-Expression

# Function to set up the LLVM-MinGW environment
function Use-LLVM {
    $llvmPath = "C:\llvm-mingw\bin"
    Write-Host "Adding LLVM-MinGW to PATH: $llvmPath" -ForegroundColor Green
    # Prepend LLVM path to the current session's PATH
    $env:Path = "$llvmPath;" + $env:Path
    Write-Host "LLVM-MinGW (clang, lldb) is now prioritized."
    Write-Host "Type 'clang --version' or 'gcm make' (Get-Command make) to test."
}

# Function to set up the WinLibs (GCC) environment
function Use-GCC {
    $gccPath = "C:\winlibs-mingw64\bin"
    Write-Host "Adding WinLibs (GCC) to PATH: $gccPath" -ForegroundColor Cyan
    # Prepend GCC path to the current session's PATH
    $env:Path = "$gccPath;" + $env:Path
    Write-Host "WinLibs (GCC) is now prioritized."
    Write-Host "Type 'gcc --version' or 'gcm make' (Get-Command make) to test."
}

# Optional: A function to show which 'make' is active
function Show-Make {
    Write-Host "Checking for 'make'..."
    Get-Command make -ErrorAction SilentlyContinue | Select-Object -First 1 | Format-List Name, Source
    Write-Host "Checking for 'mingw32-make'..."
    Get-Command mingw32-make -ErrorAction SilentlyContinue | Select-Object -First 1 | Format-List Name, Source
}

Write-Host "Custom PowerShell profile loaded. Use 'Use-LLVM' or 'Use-GCC' to switch toolchains." -ForegroundColor Yellow

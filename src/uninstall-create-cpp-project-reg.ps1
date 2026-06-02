try {
    Write-Host "Removing Create C++ Project context menu..." -ForegroundColor Cyan

    $Keys = @(
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\dev_create_cpp_project",
        "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\dev_create_cpp_project"
    )

    foreach ($Key in $Keys) {
        if (Test-Path $Key) {
            Remove-Item $Key -Recurse -Force
            Write-Host "Removed: $Key" -ForegroundColor Green
        }
        else {
            Write-Host "Not found: $Key" -ForegroundColor Yellow
        }
    }

    Write-Host ""
    Write-Host "Uninstall complete." -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "Uninstall failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

Pause
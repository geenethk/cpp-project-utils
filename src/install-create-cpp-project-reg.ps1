try {
    Write-Host "Installing Create C++ Project context menu..." -ForegroundColor Cyan

    $ScriptDir = $PSScriptRoot
    $ToolPath = Join-Path $ScriptDir "project-tool.ps1"
	$IconResPath = Join-Path (Split-Path $ScriptDir -Parent) "res\cmd-icon.ico"
	
	$FolderCommand = "powershell.exe -NoExit -ExecutionPolicy Bypass -File `"$ToolPath`" `"%1`""
	$FolderKey = "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\shell\dev_create_cpp_project"
	
	$BackgroundCommand = "powershell.exe -NoExit -ExecutionPolicy Bypass -File `"$ToolPath`" `"%V`""
	$BackgroundKey = "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\dev_create_cpp_project"
	
	Write-Host "Script directory: $ScriptDir"
    Write-Host "Tool path: $ToolPath"

    if (-not (Test-Path $ToolPath)) {
        throw "project-tool.ps1 not found."
    }

    Write-Host "Creating registry keys..."
    New-Item -Path $FolderKey -Force | Out-Null
	New-Item -Path $BackgroundKey -Force | Out-Null

    Write-Host "Setting menu texts..."
    Set-ItemProperty `
        -Path $FolderKey `
        -Name "(default)" `
        -Value "Dev: Create C++ Project"
	Set-ItemProperty `
        -Path $BackgroundKey `
        -Name "(default)" `
        -Value "Dev: Create C++ Project"

	Write-Host "Setting icons..."
	Set-ItemProperty `
		-Path $FolderKey `
		-Name "Icon" `
		-Value "$IconResPath"
	Set-ItemProperty `
		-Path $BackgroundKey `
		-Name "Icon" `
		-Value "$IconResPath"

    Write-Host "Creating command keys..."
    New-Item -Path "$FolderKey\command" -Force | Out-Null
	New-Item -Path "$BackgroundKey\command" -Force | Out-Null

    Write-Host "Registering commands..."
    Set-ItemProperty `
        -Path "$FolderKey\command" `
        -Name "(default)" `
        -Value $FolderCommand
	Set-ItemProperty `
        -Path "$BackgroundKey\command" `
        -Name "(default)" `
        -Value $BackgroundCommand

    Write-Host ""
    Write-Host "Installation successful!" -ForegroundColor Green
    Write-Host "You may need to restart File Explorer if the menu doesn't appear immediately."
}
catch {
    Write-Host ""
    Write-Host "Installation failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

Pause
param(
    [string]$BaseDir
)

function Show-Menu
{
    Clear-Host
    Write-Host "===============================" -ForegroundColor Cyan
    Write-Host "     PROJECT TOOL MENU"
    Write-Host "==============================="
    Write-Host "1. Create new C++ project"
    Write-Host "2. Exit"
    Write-Host "==============================="
}

function Create-Project
{
    Write-Host "`n=== Create New Project ===" -ForegroundColor Green

    $ProjectName = Read-Host "Project name"
    
	if (-not $BaseDir)
	{
		$BaseDir = Read-Host "Base directory (e.g. D:\Projects)"
	}
    $GitUrl      = Read-Host "GitHub repo URL (press Enter to skip)"

    # Template folder is ALWAYS relative to script location
    $ScriptDir = $PSScriptRoot
	$RootDir   = Split-Path -Parent $ScriptDir
	$TemplateDir = Join-Path $RootDir "templates"

    $ProjectPath = Join-Path $BaseDir $ProjectName

    if (Test-Path $ProjectPath)
	{
        Write-Host "`nERROR: Project folder already exists!" -ForegroundColor Red
        Start-Sleep 2
        return
    }

    Write-Host "`nCreating project at: $ProjectPath" -ForegroundColor Yellow

    # -----------------------------
    # Create structure
    # -----------------------------
    New-Item -ItemType Directory -Path $ProjectPath | Out-Null

    $extra = Read-Host "Override folders (space separated) or press Enter"
    if ($extra.Trim() -ne "")
	{
        $extra.Split(" ") | ForEach-Object
		{
            New-Item -ItemType Directory -Path (Join-Path $ProjectPath $_) -Force | Out-Null
        }
    }
	else
	{
		New-Item -ItemType Directory -Path "$ProjectPath\src" | Out-Null
		New-Item -ItemType Directory -Path "$ProjectPath\include" | Out-Null
	}

    # -----------------------------
    # Copy template files
    # -----------------------------
    Write-Host "`nCopying templates..." -ForegroundColor Yellow

    Copy-Item "$TemplateDir\vcpkg.json" "$ProjectPath\" -ErrorAction SilentlyContinue
    Copy-Item "$TemplateDir\CMakeLists.txt" "$ProjectPath\" -ErrorAction SilentlyContinue
    Copy-Item "$TemplateDir\CMakePresets.json" "$ProjectPath\" -ErrorAction SilentlyContinue
    Copy-Item "$TemplateDir\.gitignore" "$ProjectPath\" -ErrorAction SilentlyContinue

    # -----------------------------
    # Git setup
    # -----------------------------
    Write-Host "`nInitializing Git..." -ForegroundColor Yellow

    if (-not (Get-Command git -ErrorAction SilentlyContinue))
	{
        Write-Host "ERROR: Git is not installed or not in PATH!" -ForegroundColor Red
        return
    }

    Push-Location $ProjectPath

    git init | Out-Null
    git branch -M main

    if ($GitUrl.Trim() -ne "")
	{
        git remote add origin $GitUrl
        Write-Host "GitHub remote connected." -ForegroundColor Green
    }
    else
	{
        Write-Host "No GitHub URL provided. Skipping remote setup." -ForegroundColor DarkGray
    }

    Pop-Location

    Write-Host "`nProject created successfully!" -ForegroundColor Green
    Pause
}

# -----------------------------
# MAIN LOOP
# -----------------------------
while ($true)
{
	if (-not $BaseDir)
	{
		Show-Menu
		$choice = Read-Host "Select option"

		switch ($choice)
		{
			"1" { Create-Project }
			"2" { break }
			default
			{
				Write-Host "Invalid option" -ForegroundColor Red
				Start-Sleep 1
			}
		}
	}
	else
	{
		Create-Project
	}
}
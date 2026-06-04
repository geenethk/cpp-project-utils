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
	
	New-Item -ItemType Directory -Force "$ProjectPath\.cmake" | Out-Null
	Copy-Item "$TemplateDir\.cmake\generate-licenses.cmake" "$ProjectPath\.cmake" -ErrorAction SilentlyContinue

	# Update vcpkg.json
	$VcpkgFile = Join-Path $ProjectPath "vcpkg.json"

	if (Test-Path $VcpkgFile)
	{
		$Baseline = git -C $env:VCPKG_ROOT rev-parse HEAD
		
		$json = Get-Content $VcpkgFile -Raw | ConvertFrom-Json
		$json.name = $ProjectName.ToLower()
		$json."builtin-baseline" = $Baseline

		$json | ConvertTo-Json -Depth 10 | Set-Content $VcpkgFile
	}
	
	# -----------------------------
	# Detect CMake version
	# -----------------------------
	$CMakeVersion = $null
	if (Get-Command cmake -ErrorAction SilentlyContinue)
	{
		$Output = cmake --version 2>$null | Out-String
		if ($Output -match "cmake version\s+(\d+\.\d+)")
		{
			$CMakeVersion = $matches[1]
		}
	}

	if (-not $CMakeVersion)
	{
		Write-Host "WARNING: Could not detect CMake version. Using fallback." -ForegroundColor Yellow
		$CMakeVersion = "3.20"
	}

	# -----------------------------
	# Customize CMakeLists.txt
	# -----------------------------
	$CmakeFile = Join-Path $ProjectPath "CMakeLists.txt"

	if (Test-Path $CmakeFile)
	{
		$content = Get-Content $CmakeFile -Raw

		$content = $content.Replace("%VERSION_HERE%", $CMakeVersion)
		$content = $content.Replace("%PROJECT_NAME_HERE%", $ProjectName)

		Set-Content $CmakeFile $content
	}

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
if (-not $BaseDir)
{
	while ($true)
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
}
else
{
	Create-Project
}
exit
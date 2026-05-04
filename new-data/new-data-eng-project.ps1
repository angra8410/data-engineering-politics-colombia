param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $false)]
    [string]$GitHubUrl = "",

    [Parameter(Mandatory = $false)]
    [switch]$InitGit,

    [Parameter(Mandatory = $false)]
    [switch]$PushGit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$basePath = Get-Location
$projectPath = Join-Path $basePath $ProjectName

if (Test-Path -LiteralPath $projectPath) {
    throw "La carpeta del proyecto ya existe: $projectPath"
}

New-Item -ItemType Directory -Path $projectPath | Out-Null

$folders = @(
    "docs",
    "fabric\pipelines",
    "fabric\notebooks",
    "fabric\lakehouse",
    "sql\ingestion",
    "sql\transformations",
    "sql\validations",
    "powerbi\pbix",
    "powerbi\templates",
    "exports\csv",
    "exports\parquet",
    "exports\snapshots",
    "assets\screenshots",
    "assets\diagrams"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path (Join-Path $projectPath $folder) -Force | Out-Null
}

Set-Location -LiteralPath $projectPath

if ($InitGit -or $PushGit) {
    git init
    git add .
    git commit -m "Initial project structure"
    git branch -M main

    if (-not [string]::IsNullOrWhiteSpace($GitHubUrl)) {
        git remote add origin $GitHubUrl
    }
}

if ($PushGit) {
    if ([string]::IsNullOrWhiteSpace($GitHubUrl)) {
        throw "Para hacer push debes enviar -GitHubUrl."
    }
    git push -u origin main
}

Write-Host "Proyecto creado en: $projectPath"
Write-Host "Estructura base generada correctamente."

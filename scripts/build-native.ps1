$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Entry = Join-Path $Root "native-host\youtube_local_exporter_host.py"
$Dist = Join-Path $Root "native-host\dist"
$Build = Join-Path $Root "native-host\build"

New-Item -ItemType Directory -Force -Path $Dist, $Build | Out-Null

uv tool run pyinstaller `
  --onefile `
  --clean `
  --name youtube-local-exporter-host `
  --distpath $Dist `
  --workpath $Build `
  --specpath $Build `
  $Entry

Write-Host "Built native host in $Dist"

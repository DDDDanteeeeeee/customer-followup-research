#Requires -Version 5.1
param([string]$CustomerName = "", [string[]]$FilePaths = @(), [switch]$DetectOnly)

$r = @{ files = @(); obsidian = $null }

if ($FilePaths.Count -eq 0) {
    $patterns = @("*tracking*", "*customer*", "*pipeline*")
    $roots = @("$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents", "D:\codexproject")
    foreach ($root in $roots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        foreach ($pat in $patterns) {
            try {
                Get-ChildItem -LiteralPath $root -Filter $pat -File -Recurse -Depth 2 -ErrorAction SilentlyContinue |
                    Where-Object { $_.Extension -in ".xlsx", ".xls", ".csv", ".md" } |
                    ForEach-Object {
                        $r.files += @{ name = $_.Name; path = $_.FullName; modified = $_.LastWriteTime.ToString("yyyy-MM-dd"); sizeKB = [math]::Round($_.Length / 1KB, 1) }
                    }
            } catch { continue }
        }
    }
    if ($r.files.Count -gt 15) { $r.files = $r.files | Select-Object -First 15 }
} else {
    foreach ($fp in $FilePaths) {
        if (Test-Path -LiteralPath $fp) {
            $fi = Get-Item -LiteralPath $fp
            $r.files += @{ name = $fi.Name; path = $fi.FullName; modified = $fi.LastWriteTime.ToString("yyyy-MM-dd"); sizeKB = [math]::Round($fi.Length / 1KB, 1) }
        } else {
            $r.files += @{ name = $fp; path = $fp; error = "not found" }
        }
    }
}

$obsPaths = @(
    "$env:USERPROFILE\Documents\Obsidian Vault",
    "$env:USERPROFILE\Obsidian",
    "D:\Obsidian"
)
foreach ($p in $obsPaths) {
    $obsDir = Join-Path $p ".obsidian"
    if (Test-Path -LiteralPath $obsDir -PathType Container) {
        $r.obsidian = @{ available = $true; path = $p }
        break
    }
}

if ($CustomerName -and -not $DetectOnly) {
    foreach ($fileInfo in $r.files) {
        $fp = $fileInfo.path
        if (-not (Test-Path -LiteralPath $fp)) { continue }
        $ext = [System.IO.Path]::GetExtension($fp).ToLower()
        if ($ext -eq ".md" -or $ext -eq ".csv" -or $ext -eq ".txt") {
            try {
                $content = Get-Content -LiteralPath $fp -Raw -ErrorAction SilentlyContinue
                if ($content -and $content.Contains($CustomerName)) {
                    $fileInfo.customerMatch = $true
                }
            } catch { continue }
        }
    }
    if ($r.obsidian -and $r.obsidian.available) {
        try {
            $vaultPath = $r.obsidian.path
            $mdFiles = Get-ChildItem -LiteralPath $vaultPath -Filter "*.md" -Recurse -ErrorAction SilentlyContinue |
                Where-Object {
                    $c = Get-Content -LiteralPath $_.FullName -Raw -ErrorAction SilentlyContinue
                    $c -and $c.Contains($CustomerName)
                } |
                Select-Object -First 5
            if ($mdFiles) {
                $r.obsidian.customerMatches = @($mdFiles | ForEach-Object { @{ file = $_.FullName; name = $_.Name } })
            }
        } catch { continue }
    }
}

$r | ConvertTo-Json -Depth 5

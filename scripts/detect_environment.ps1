#Requires -Version 5.1
param([string]$CustomerName = "", [switch]$SkipOdoo, [switch]$SkipOutlook, [switch]$SkipFiles)

$r = @{}

if (-not $SkipOutlook) {
    try {
        $o = New-Object -ComObject Outlook.Application -ErrorAction Stop
        $n = $o.GetNamespace("MAPI")
        $inbox = $n.GetDefaultFolder(6)
        $sent = $n.GetDefaultFolder(5)
        $os = @{ available = $true; inboxCount = $inbox.Items.Count; sentCount = $sent.Items.Count }
        if ($CustomerName.Length -gt 1) {
            $pat = [regex]::Escape($CustomerName)
            $mi = 0; $ms = 0
            $li = ""; $lo = ""
            foreach ($item in $inbox.Items) {
                if (($item.Subject -and $item.Subject -match $pat) -or ($item.Body -and $item.Body -match $pat)) {
                    $mi++
                    $d = $item.ReceivedTime.ToString("yyyy-MM-dd")
                    if ($d -gt $li) { $li = $d }
                }
            }
            foreach ($item in $sent.Items) {
                if (($item.Subject -and $item.Subject -match $pat) -or ($item.Body -and $item.Body -match $pat)) {
                    $ms++
                    $d = $item.SentOn.ToString("yyyy-MM-dd")
                    if ($d -gt $lo) { $lo = $d }
                }
            }
            $os.customerMatches = @{ name = $CustomerName; inboxHits = $mi; sentHits = $ms; lastInbound = $li; lastOutbound = $lo }
        }
        $r.outlook = $os
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($o) | Out-Null
    } catch {
        $r.outlook = @{ available = $false; reason = $_.Exception.Message }
    }
}

if (-not $SkipOdoo) {
    $odooFound = $false
    foreach ($port in @(8069, 8070, 4780, 4797)) {
        try {
            $uri = "http://127.0.0.1:$port/web/webclient/version_info"
            $resp = Invoke-WebRequest -Uri $uri -TimeoutSec 3 -ErrorAction Stop -UseBasicParsing
            if ($resp.StatusCode -eq 200) {
                $r.odoo = @{ available = $true; host = $uri; note = "Session required" }
                $odooFound = $true
                break
            }
        } catch { continue }
    }
    if (-not $odooFound) { $r.odoo = @{ available = $false; reason = "Not detected" } }
}

$obsPaths = @(
    "$env:USERPROFILE\Documents\Obsidian Vault",
    "$env:USERPROFILE\Obsidian",
    "D:\Obsidian"
)
$r.obsidian = @{ available = $false; reason = "Not found" }
foreach ($p in $obsPaths) {
    $obsDir = Join-Path $p ".obsidian"
    if (Test-Path -LiteralPath $obsDir -PathType Container) {
        $r.obsidian = @{ available = $true; path = $p }
        break
    }
}

$patterns = @("*tracking*", "*customer*", "*pipeline*")
$roots = @("$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents", "D:\codexproject")
$tracked = @()
foreach ($root in $roots) {
    if (-not (Test-Path -LiteralPath $root)) { continue }
    foreach ($pat in $patterns) {
        try {
            Get-ChildItem -LiteralPath $root -Filter $pat -File -Recurse -Depth 2 -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -in ".xlsx", ".xls", ".csv", ".md" } |
                ForEach-Object { $tracked += @{ name = $_.Name; path = $_.FullName; modified = $_.LastWriteTime.ToString("yyyy-MM-dd") } }
        } catch { continue }
    }
}
$r.files = @{ available = ($tracked.Count -gt 0); count = $tracked.Count; items = $tracked }

$conn = @()
$miss = @()
if ($r.outlook -and $r.outlook.available) { $conn += "Outlook" } else { $miss += "Outlook" }
if ($r.odoo -and $r.odoo.available) { $conn += "Odoo" } else { $miss += "Odoo" }
if ($r.obsidian -and $r.obsidian.available) { $conn += "Obsidian" }
if ($r.files -and $r.files.available) { $conn += "Files" }

$summary = "Connected: " + ($conn -join ", ") + " / Missing: " + ($miss -join ", ")
$r.summary = $summary

$r | ConvertTo-Json -Depth 5

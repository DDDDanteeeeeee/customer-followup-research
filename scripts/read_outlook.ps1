#Requires -Version 5.1
<#
.SYNOPSIS
  Read customer-related emails from Outlook and output a structured timeline.
.DESCRIPTION
  Connects to Outlook COM, searches Inbox + Sent Messages for the customer name,
  extracts subject / date / direction / first 200 chars of body, outputs JSON.
.EXAMPLE
  .\read_outlook.ps1 -CustomerName "Alpha Tracking" -MaxEmails 30
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$CustomerName,
    [int]$MaxEmails = 30,
    [string]$OutputPath = ""
)

$outlook = $null
try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $ns = $outlook.GetNamespace("MAPI")
} catch {
    @{ error = "Cannot connect to Outlook COM: $($_.Exception.Message)"; emails = @() } | ConvertTo-Json -Depth 3
    exit 1
}

$emailList = @()
$folders = @(
    @{ obj = $ns.GetDefaultFolder(6); direction = "inbound" },   # olFolderInbox
    @{ obj = $ns.GetDefaultFolder(5); direction = "outbound" }    # olFolderSentMail
)

foreach ($folderInfo in $folders) {
    $folder = $folderInfo.obj
    $direction = $folderInfo.direction
    $count = 0

    foreach ($item in $folder.Items) {
        if ($count -ge $MaxEmails) { break }

        $subjectMatch = $item.Subject -and ($item.Subject -match [regex]::Escape($CustomerName))
        $bodyMatch    = $item.Body -and ($item.Body -match [regex]::Escape($CustomerName))

        if ($subjectMatch -or $bodyMatch) {
            $date = if ($direction -eq "inbound") { $item.ReceivedTime } else { $item.SentOn }
            $bodyPreview = ""
            if ($item.Body) {
                $bodyPreview = ($item.Body -replace '\r?\n', ' ').Trim()
                if ($bodyPreview.Length -gt 200) { $bodyPreview = $bodyPreview.Substring(0, 200) + "..." }
            }

            $emailList += @{
                date      = $date.ToString("yyyy-MM-dd HH:mm")
                direction = $direction
                subject   = $item.Subject
                sender    = if ($direction -eq "inbound") { $item.SenderName } else { "me" }
                recipient = if ($direction -eq "outbound") { $item.To } else { "me" }
                bodyPreview = $bodyPreview
            }
            $count++
        }
    }
}

# Sort by date
$emailList = $emailList | Sort-Object { [datetime]$_.date }

$out = @{
    customer = $CustomerName
    totalEmails = $emailList.Count
    retrievedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    emails = $emailList
}

if ($OutputPath) {
    $out | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
    Write-Output "Saved to $OutputPath"
} else {
    $out | ConvertTo-Json -Depth 5
}

if ($outlook) {
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($outlook) | Out-Null
}

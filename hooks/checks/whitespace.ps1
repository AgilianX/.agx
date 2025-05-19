#!/usr/bin/env pwsh
# whitespace.ps1 - PowerShell version of whitespace.sh
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Files
)
$skipExt = @('png', 'jpg', 'jpeg', 'gif', 'ico', 'zip', 'gz', 'tar', 'rar', '7z', 'exe', 'dll', 'pdf', 'mp3', 'mp4', 'mov', 'avi', 'bin', 'fig')
foreach ($file in $Files) {
    if ($file -eq $MyInvocation.MyCommand.Path) { continue }
    $ext = [System.IO.Path]::GetExtension($file).TrimStart('.')
    if ($skipExt -contains $ext) { continue }
    $hasWhitespace = Select-String -Path $file -Pattern '\s+$' -AllMatches
    if ($hasWhitespace) {
        Write-Host "❌ Found trailing whitespace in: $file"
        exit 1
    }
}
exit 0

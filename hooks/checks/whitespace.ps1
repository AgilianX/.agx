#!/usr/bin/env pwsh
# whitespace.ps1 - PowerShell version of whitespace.sh

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string]$File
)
$skipExt = @('png', 'jpg', 'jpeg', 'gif', 'ico', 'zip', 'gz', 'tar', 'rar', '7z', 'exe', 'dll', 'pdf', 'mp3', 'mp4', 'mov', 'avi', 'bin', 'fig')

$ext = [System.IO.Path]::GetExtension($File).TrimStart('.')
if ($skipExt -contains $ext) { exit 0 }

$hasWhitespace = Select-String -Path $File -Pattern '\s+$' -AllMatches
if ($hasWhitespace) {
    Write-Host "❌ Found trailing whitespace in: $File"
    exit 1
}

exit 0

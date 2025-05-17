param(
    [Parameter(Mandatory)]$AgxPaths,
    [Parameter()]$isInAgxRoot = $false
)
$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Write-Host '|   "powershell-yaml" module is required. Install now? [Y/n]' -ForegroundColor Yellow
    Write-Host '|   ' -NoNewline
    $response = Read-Host
    if ($response -eq '' -or $response -match '^(y|Y)') {
        Install-Module powershell-yaml -Scope CurrentUser
    }
    else {
        # If not in .agx root, set useAliases = false in .gitmodules using git config and notify user
        if (-not $isInAgxRoot) {
            git config -f .gitmodules submodule..agx.useAliases false
            Write-Host '|   "powershell-yaml" module not installed. "useAliases" set to "false" in .gitmodules' -ForegroundColor Yellow
        }
        else {
            git config --local agx.useAliases false
            Write-Host '|   "powershell-yaml" module not installed. "useAliases" set to "false" in local git config' -ForegroundColor Yellow
        }

        exit 0
    }
}

Import-Module powershell-yaml -ErrorAction Stop

$aliasesFile = Join-Path $AgxPaths.Tools.Absolute 'aliases.yml'
$aliases = ConvertFrom-Yaml -Yaml (Get-Content $aliasesFile -Raw)
$count = 0
foreach ($aliasKey in ($aliases.Keys | Sort-Object)) {
    # Only register demo aliases if in .agx root
    if ($aliasKey -like 'agx-demo-*' -and -not $isInAgxRoot) { continue }

    $aliasValue = $aliases[$aliasKey]
    # Support new YAML object format: { shell: pwsh|sh, script: <block> }
    if ($aliasValue -is [System.Collections.Hashtable]) {
        $shell = $aliasValue['shell']
        $script = $aliasValue['script']
        $lines = $script -split '\n' | ForEach-Object { $_.TrimEnd() }
        if ($shell -eq 'pwsh') {
            $joined = ($lines -join "`n")
            $aliasValue = "!pwsh -NoProfile -Command '" + $joined.Replace("'", "''") + "'"
        }
        elseif ($shell -eq 'bash') {
            $joined = ($lines -join "`n")
            $aliasValue = "!sh -c '" + $joined.Replace("'", "'\\''") + "'"
        }
        else {
            throw "Invalid shell type '$shell' for alias '$aliasKey'. Supported types are 'pwsh' and 'bash'."
        }
    }
    else {
        $aliasValue = $aliasValue.Trim()
        if ($aliasValue -match '\n') {
            throw "Multiline alias '$aliasKey' must specify a shell and use the object format: { shell: sh|pwsh, script: <block> }"
        }
    }

    # Path logic: always use the relative paths for git config
    $aliasValue = $aliasValue -replace '.agx/tools/', "$($AgxPaths.Tools.Relative)/"
    $aliasValue = $aliasValue -replace '.agx/hooks/', "$($AgxPaths.Hooks.Relative)/"
    $currentValue = git config --local --get "alias.$aliasKey" 2>$null

    function Get-Normalized-AliasString($s) {
        if ($null -eq $s) { return '' }
        # Replace all newlines (CRLF, LF, CR) with a space
        $s = $s -replace "(`r`n|`n|`r)", ' '
        # Collapse all whitespace to a single space
        $s = $s -replace '\\s+$', ''
        return "$s"
    }

    $normalizedCurrent = Get-Normalized-AliasString $currentValue
    $normalizedAlias = Get-Normalized-AliasString $aliasValue

    if (-not $currentValue) {
        git config --local "alias.$aliasKey" $aliasValue
        $count++
    }
    elseif ($normalizedCurrent -ne $normalizedAlias) {
        Write-Host "└─▶🔄 Updating Git alias: $aliasKey" -ForegroundColor Blue
        Write-Host "|`n|   Old:`n$normalizedCurrent" -ForegroundColor DarkGray
        Write-Host "|`n|   New:`n$normalizedAlias`n|" -ForegroundColor Gray
        git config --local "alias.$aliasKey" $aliasValue
        $count++
    }
}

if ($count -ne 0) { Write-Host "└─▶✅ $count Git-AgX aliases installed successfully" -ForegroundColor Green }

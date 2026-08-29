 #Requires -Version 5.1

function Import-DotEnv {
    <#
    .SYNOPSIS
        Parses a .env file into a hashtable.

    .DESCRIPTION
        Reads KEY=VALUE lines. Skips blanks and # comments.
        Strips an optional bash-style "export " prefix and matching quotes.

    .PARAMETER Path
        Path to the env file. Defaults to .env in the current directory.

    .EXAMPLE
        Import-Module ImportDotEnv
        $vars = Import-DotEnv
        $vars.API_KEY

    .EXAMPLE
        Import-DotEnv -Path "C:\app\.env"
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = ".env"
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Env file not found: $Path"
    }

    $EnvMap = @{}

    Get-Content -LiteralPath $Path | ForEach-Object {
        $Line = $_.Trim()

        if ($Line -eq "" -or $Line.StartsWith("#")) { return }

        if ($Line -match '^\s*export\s+') {
            $Line = $line -replace '^\s*export\s+', ''
        }

        $EqIndex = $Line.IndexOf("=")
        if ($EqIndex -lt 1) { return }

        $Key   = $Line.Substring(0, $EqIndex).Trim()
        $Value = $Line.Substring($EqIndex + 1).Trim()

        if (
            ($Value.StartsWith('"') -and $Value.EndsWith('"')) -or
            ($Value.StartsWith("'") -and $Value.EndsWith("'"))
        ) {
            $Value = $Value.Substring(1, $Value.Length - 2)
        }

        $EnvMap[$Key] = $Value
    }

    return $EnvMap
}


function Set-DotEnv {
    <#
    .SYNOPSIS
        Loads a .env file into the current process environment.

    .DESCRIPTION
        Calls Import-DotEnv, then Set-Item Env:KEY for each entry.
        Affects only this process and children.

    .PARAMETER Path
        Path to the env file. Defaults to .env in the current directory.

    .EXAMPLE
        Set-DotEnv
        $env:API_KEY
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = ".env"
    )

    $Map = Import-DotEnv -Path $Path
    foreach ($Key in $Map.Keys) {
        Set-Item -Path ("Env:{0}" -f $Key) -Value $Map[$Key]
    }

    return $Map
}

Export-ModuleMember -Function Import-DotEnv, Set-DotEnv


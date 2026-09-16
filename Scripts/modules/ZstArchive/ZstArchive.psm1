function Compress-Zst {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    $Item    = Get-Item -LiteralPath $Path -ErrorAction Stop
    $Archive = Join-Path (Get-Location).Path ($Item.Name + ".tar.zst")
    $TarArgs = @(
        "--zstd"
        "--options"
        "zstd:threads=0,zstd:compression-level=19"
        "-cf"
        $Archive
        "-C"
        $Item.DirectoryName
        $Item.Name
    )

    if (Test-Path -LiteralPath $Archive) {
        throw "Compress-Zst: archive already exists ($Archive)"
    }

    $Params = [ordered]@{
        FilePath     = "tar.exe"
        ArgumentList = $TarArgs
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
    }

    $Proc = Start-Process @Params

    if ($Proc.ExitCode -ne 0) {
        throw "Compress-Zst: failed to compress archive ($($Proc.ExitCode))"
    }
}

function Expand-Zst {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$Destination = (Get-Location).Path
    )

    $Item = Get-Item -LiteralPath $Path -ErrorAction Stop

    if ($Item.PSIsContainer) {
        throw "Expand-Zst: expects file, got directory ($($Item.FullName))"
    }

    if (-not (Test-Path -LiteralPath $Destination -PathType Container)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $TarArgs = @(
        "-xf"
        $Item.FullName
        "-C"
        $Destination
    )

    $Params = [ordered]@{
        FilePath     = "tar.exe"
        ArgumentList = $TarArgs
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
    }

    $Proc = Start-Process @Params

    if ($Proc.ExitCode -ne 0) {
        throw "Expand-Zst: failed to extract archive ($($Proc.ExitCode))"
    }
}

Export-ModuleMember -Function Compress-Zst, Expand-Zst


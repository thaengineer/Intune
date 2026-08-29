<h1 align="center">
  Microsoft Intune Platform Config &amp; Automation
</h1>

<p align="center">
Win32 app packages, ADMX templates, Graph helpers, and packaging tooling — organized so you can wrap an installer, detect it, and ship it to Intune without reinventing the wheel.
</p>

<p align="center">
  <a href="#"><img alt="License" src="https://img.shields.io/github/license/thaengineer/Intune?color=blue"></a>
  <a href="https://intune.microsoft.com"><img alt="Intune" src="https://img.shields.io/badge/Microsoft-Intune-blue"></a>
  <a href="https://github.com/PowerShell/PowerShell"><img alt="PowerShell" src="https://img.shields.io/badge/Powershell-5.1-blue"></a>
  <a href="#"><img alt="Repo Size" src="https://img.shields.io/github/repo-size/thaengineer/Intune?color=green"></a>
  <a href="#"><img alt="Last Commit" src="https://img.shields.io/github/last-commit/thaengineer/Intune?color=green"></a>
</p>

---

## Features

|  | Feature |
| --- | --- |
| [x] | Win32App App Packaging |
| [ ] | ADMX Template Import/Configuration |
| [ ] | More to come |

- [x] Win32App App Packaging
- [ ] ADMX Template Import/Configuration
- [ ] More to come

---

## What's in here

| Path | Purpose |
| --- | --- |
| [`Packages/`](packages) | Win32App Templates |
| [`Scripts/`](scripts) | Packaging / Configuration (MS Graph), MS Graph Bootstrap Module, MDM Diagnostics, Deferred Install UX. |
| [`admx/`](admx) | Administrative Templates |
| [`bin/`](bin) | Microsoft `IntuneWinAppUtil.exe` and `IntuneWinAppUtilDecoder.exe`. |
| [`Assets/`](Assets) | Branding / Wallpaper source files. |

---

## Package Convention

Every Win32App under [`Packages/`](packages) follows the same shape:

```text
Packages/<App Name>/
├── Package/              # source folder passed to IntuneWinAppUtil
│   ├── setup.ps1         # Install | Uninstall
│   └── <installer bits>  # exe, msi, cab, policies.json, ...
├── detection.ps1         # Intune detection rule (script)
├── <image>.png           # Win32App Icon
└── manifest.json         # Win32App Package Details
```

`setup.ps1` always accepts `-Action Install|Uninstall` (defaults to `Install`).

```powershell
# Install
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"

# Uninstall
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
```

---

## Scripts

| Script | What it does |
| --- | --- |
| [`Scripts/New-Intunewin.ps1`](Scripts/New-Intunewin.ps1) | Runs `IntuneWinAppUtil.exe` against `.\Package` with `setup.ps1` as the setup file. |
| [`Scripts/New-IntuneWin32App.ps1`](Scripts/New-IntuneWin32App.ps1) | Uploads a `.intunewin` to Intune via the [IntuneWin32App](https://github.com/MSEndpointMgr/IntuneWin32App) module. |

### Graph and workstation setup

| Script | What it does |
| --- | --- |
| [`Scripts/Install-PSModules.ps1`](Scripts/Install-PSModules.ps1) | Installs `MSI`, `PSMSI`, `ps2exe`, `IntuneWin32App`, `Microsoft.Graph` for the current user. |
| [`Scripts/Install-MSGraph.ps1`](Scripts/Install-MSGraph.ps1) | Resolves the latest `Microsoft.Graph` version from the Gallery and installs it. |
| [`Scripts/Test-MSGraph.ps1`](Scripts/Test-MSGraph.ps1) | Loads `.env` via `ImportDotEnv`, connects with client-secret credentials, prints `Get-MgContext`. |
| [`Scripts/Export-MDMDiagnostics.ps1`](Scripts/Export-MDMDiagnostics.ps1) | Dumps MDM diagnostics to the desktop (`mdm\`) plus area CABs: Autopilot, DeviceEnrollment, DeviceProvisioning, OsConfiguration, Tpm. |
| - | - |

### Helpers

| Path | What it does |
| --- | --- |
| [`Scripts/modules/ImportDotEnv`](Scripts/modules/ImportDotEnv) | `Import-DotEnv` / `Set-DotEnv` — parse a `.env` file into process environment variables. |
| [`Scripts/deferred-setup`](Scripts/deferred-setup) | Toast-style deferral UI (`ToastHelper`) plus a sample progress `setup.ps1`. (**work in progress**) |
| [`Scripts/make-msi`](Scripts/make-msi) | Templates for wrapping files into an MSI (`PSMSI`) and compiling a script to an exe (`ps2exe`). (**work in progress**) |
| [ ] | |

---

## Getting started

### Prerequisites

- Windows 10/11 admin workstation
- PowerShell 5.1
- An Entra ID app registration with Intune / Graph application permissions if you publish via Graph
- This repo cloned locally

```powershell
git clone https://github.com/thaengineer/Intune.git
cd Intune
```

### 1. Install helper modules

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Scripts\Install-PSModules.ps1
```

### 2. Graph connection (optional)

Create a `.env` in the repo root. It is already gitignored.

```env
TenantID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ClientID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ClientSecret=your-client-secret
```

```powershell
.\Scripts\Test-MSGraph.ps1
```

Required Graph application permissions depend on what you call. For Win32 app upload via `IntuneWin32App`, start with:

- `DeviceManagementApps.ReadWrite.All`
- `DeviceManagementConfiguration.ReadWrite.All` (if you also push policies)

Grant admin consent in Entra ID.

### 3. Wrap a package

```powershell
cd ".\Packages\7-Zip 26.02"

# preferred: repo-local util
..\..\bin\IntuneWinAppUtil.exe -c .\Package -s .\Package\setup.ps1 -o .\
```

Then either upload the `.intunewin` in the Intune admin center, or run `New-IntuneWin32App.ps1` after you replace the placeholder display name / publisher / version.

### 4. Collect MDM logs from a problem device

```powershell
.\Scripts\Export-MDMDiagnostics.ps1
# output: %USERPROFILE%\Desktop\mdm\
```

---

## ADMX templates

Import these into Intune as **Imported administrative templates (Preview)** or stage them in a Central Store if you still use on-prem GPO.

Pair Firefox ADMX with the `policies.json` already baked into the Firefox Win32 packages when you want settings that survive even if ADMX import is delayed.

---

## Disclaimer

Scripts and packages are provided **as-is**. Test in a lab or pilot ring before production.

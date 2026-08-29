# Intune
Intune Platform Config &amp; Automation

**Platform configuration and automation for Microsoft Intune.**

Win32 app packages, ADMX templates, Graph helpers, and packaging tooling — organized so you can wrap an installer, detect it, and ship it to Intune without reinventing the folder layout every time.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://raw.githubusercontent.com/thaengineer/Intune/refs/heads/main/LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Intune](https://img.shields.io/badge/Microsoft-Intune-0078D4.svg)](https://intune.microsoft.com)

---

## What's in here

| Path | Purpose |
| --- | --- |
| [`Packages/`](Packages) | Ready-to-wrap Win32 apps. Each app has a `Package/` payload, `detection.ps1`, and an icon. |
| [`Scripts/`](Scripts) | Packaging, Graph auth, module bootstrap, MDM diagnostics, deferred install UX. |
| [`admx/`](admx) | Administrative templates for **Firefox** and **Microsoft Edge** (plus Edge Update / WebView2). |
| [`bin/`](bin) | Microsoft `IntuneWinAppUtil.exe` and `IntuneWinAppUtilDecoder.exe`. |
| [`Assets/`](Assets) | Branding / wallpaper source files. |

---

## Package convention

Every Win32 app under `Packages/` follows the same shape:

```text
Packages/<App Name> <Version>/
├── Package/              # source folder passed to IntuneWinAppUtil
│   ├── setup.ps1         # Install | Uninstall | Repair
│   └── <installer bits>  # exe, msi, cab, policies.json, …
├── detection.ps1         # Intune detection rule (script)
└── icon.png              # Company Portal icon
```

`setup.ps1` always accepts `-Action Install|Uninstall|Repair` (default `Install`). Intune command lines:

```powershell
# Install
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"

# Uninstall
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
```

### Current packages

| Package | Notes |
| --- | --- |
| **7-Zip 26.02** | Silent `/S` install. Uninstall via `Uninstall.exe`. |
| **CMTrace 5.00.9078.1000** | Ships the CMTrace binary in `Package/`. |
| **Company Portal** | Icon only (Store / Microsoft app assignment). |
| **Mozilla Firefox 153.0.1** | Silent install via `install.ini`, then drops `policies.json` into `distribution\`. |
| **Mozilla Firefox ESR 140.13.0** | Same pattern as release Firefox, ESR channel. |
| **Orca 10.1.28000.2526** | MSI + supporting CABs. |
| **PowerShell x64 7.6.4** | Silent install wrapper. |
| **Uninstall Bloatware** | Removes a fixed list of inbox Appx packages (Solitaire, Clipchamp-adjacent inbox apps, Your Phone, etc.). |

Firefox packages copy enterprise `policies.json` to:

```text
C:\Program Files\Mozilla Firefox\distribution\policies.json
```

That is the supported way to lock settings without relying on GPO on every device.

---

## Scripts

### Packaging and publish

| Script | What it does |
| --- | --- |
| [`Scripts/New-Intunewin.ps1`](Scripts/New-Intunewin.ps1) | Runs `IntuneWinAppUtil.exe` against `.\Package` with `setup.ps1` as the setup file, then renames `setup.intunewin` to the parent folder name. |
| [`Scripts/New-IntuneWin32App.ps1`](Scripts/New-IntuneWin32App.ps1) | Uploads a `.intunewin` to Intune via the [IntuneWin32App](https://github.com/MSEndpointMgr/IntuneWin32App) module. Detection script + icon + requirement rule (x86/x64, Windows 10 1607+). Marked work-in-progress. |

Typical wrap from a package folder (adjust the util path if you are not on the lab drive):

```powershell
# from Packages/<App>/
& "$PSScriptRoot\..\..\bin\IntuneWinAppUtil.exe" -c .\Package -s .\Package\setup.ps1 -o .\
```

`New-Intunewin.ps1` currently points at `Z:\IntuneLab\bin\IntuneWinAppUtil.exe`. Change that path, or call `bin\IntuneWinAppUtil.exe` from this repo instead.

### Graph and workstation setup

| Script | What it does |
| --- | --- |
| [`Scripts/Install-PSModules.ps1`](Scripts/Install-PSModules.ps1) | Installs `MSI`, `PSMSI`, `ps2exe`, `IntuneWin32App`, `Microsoft.Graph` for the current user. |
| [`Scripts/Install-MSGraph.ps1`](Scripts/Install-MSGraph.ps1) | Resolves the latest `Microsoft.Graph` version from the Gallery and installs it. |
| [`Scripts/Test-MSGraph.ps1`](Scripts/Test-MSGraph.ps1) | Loads `.env` via `ImportDotEnv`, connects with client-secret credentials, prints `Get-MgContext`. |
| [`Scripts/Export-MDMDiagnostics.ps1`](Scripts/Export-MDMDiagnostics.ps1) | Dumps MDM diagnostics to the desktop (`mdm\`) plus area CABs: Autopilot, DeviceEnrollment, DeviceProvisioning, OsConfiguration, Tpm. |

### Helpers

| Path | What it does |
| --- | --- |
| [`Scripts/modules/ImportDotEnv`](Scripts/modules/ImportDotEnv) | `Import-DotEnv` / `Set-DotEnv` — parse a `.env` file into process environment variables. |
| [`Scripts/deferred-setup`](Scripts/deferred-setup) | Toast-style deferral UI (`ToastHelper`) plus a sample progress `setup.ps1`. Lets a user postpone an install a few times before it runs. |
| [`Scripts/make-msi`](Scripts/make-msi) | Templates for wrapping files into an MSI (`PSMSI`) and compiling a script to an exe (`ps2exe`). Placeholders, not production product names. |

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


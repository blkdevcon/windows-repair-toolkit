# Release Notes — v1.0.0

**Release Date:** November 1, 2026  
**Type:** Initial Release

---

## Overview

Version 1.0 is the initial public release of the **Windows Repair Toolkit** — a single-file, administrator-run batch script that consolidates the most commonly needed Windows diagnostic and repair tools into one numbered menu. No installation required. No third-party dependencies. Every operation is automatically logged to a timestamped file on the Desktop.

---

## What's Included

### Core Features

- **Interactive menu** — numbered options 1 through 17, with input validation and automatic return to menu after each operation
- **Administrator check** — script refuses to run without elevated privileges and displays a clear error message
- **Automatic logging** — every operation is written to `%USERPROFILE%\Desktop\WRT_YYYY-MM-DD.log` with timestamps; log path is displayed in the menu header

---

### Menu Options (v1.0)

#### System Repair
| Option | Name | Command |
|--------|------|---------|
| [1] | System File Checker (SFC) | `sfc /scannow` |
| [2] | DISM Restore Health | `DISM /Online /Cleanup-Image /RestoreHealth` |
| [3] | DISM Scan Health | `DISM /Online /Cleanup-Image /ScanHealth` |
| [5] | Windows Component Cleanup | `DISM /Online /Cleanup-Image /StartComponentCleanup` |
| [9] | DISM Check Health | `DISM /Online /Cleanup-Image /CheckHealth` |
| [11] | Run Recommended Repair Sequence | Runs options 9 → 3 → 2 → 1 in order |

#### Storage
| Option | Name | Command |
|--------|------|---------|
| [4] | Check Disk Errors (C:) | `chkdsk C: /f /r /x` |

#### Network
| Option | Name | Command |
|--------|------|---------|
| [6] | Reset Winsock Network | `netsh winsock reset`, `netsh int ip reset` |
| [7] | Reset TCP/IP | `netsh int tcp reset`, `netsh int ipv4 reset`, `netsh int ipv6 reset` |
| [8] | Flush DNS Cache | `ipconfig /flushdns`, `ipconfig /registerdns` |

#### Drivers
| Option | Name | Command |
|--------|------|---------|
| [12] | Driver Query | `driverquery /v` |
| [13] | Signed Drivers Info | `driverquery /si` |
| [14] | Device Problem Scan | `pnputil /enum-devices /problem` |
| [15] | Install Missing Drivers | `pnputil /scan-devices` |

#### Hardware Diagnostics
| Option | Name | Command |
|--------|------|---------|
| [10] | System Information | `systeminfo` |
| [16] | Scan RAM | `mdsched.exe` |

#### Software
| Option | Name | Command |
|--------|------|---------|
| [17] | Software Update | `winget upgrade --all` |

---

### Recommended Repair Sequence (Option 11)

Option 11 runs a full automated repair pass in Microsoft's recommended order:

1. **DISM CheckHealth** — fast check for component store corruption
2. **DISM ScanHealth** — deeper scan without making changes
3. **DISM RestoreHealth** — repairs the component store using Windows Update
4. **SFC /scannow** — scans and repairs protected system files using the now-healthy component store

Estimated time: 20–40 minutes. All steps are logged.

---

## Technical Details

- **Language:** Windows Batch (`.bat`)
- **Privilege requirement:** Administrator (`net session` check at launch)
- **Log format:** Plain text, one entry per operation, timestamped with `%time%`
- **Log location:** `%USERPROFILE%\Desktop\WRT_YYYY-MM-DD.log`
- **Compatibility:** Windows 10, Windows 11
- **Dependencies:** None — uses only built-in Windows tools

---

## Known Limitations

- **Option [4] Check Disk** — cannot run live on an active C: drive; schedules scan for next reboot instead
- **Option [16] Scan RAM** — requires a reboot to execute; results are shown post-reboot by Windows
- **Option [2] DISM Restore Health** — requires an internet connection to pull repair files from Windows Update
- **Option [15] Install Missing Drivers** — pulls from the local driver store and Windows Update; cannot install drivers that are not in either source
- **Log timestamps** use `%time%` which reflects local system time, not UTC

---

## Planned for v1.1

- Additional driver and update tooling

---

## License

Released into the public domain. Use and modify freely.

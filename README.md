# Windows Repair Toolkit

A command-line batch script for diagnosing and repairing common Windows system issues. Provides a numbered menu of built-in Windows tools — no third-party software required. All operations are logged automatically to a timestamped file on your Desktop.

---

## Requirements

- Windows 10 or Windows 11
- Must be run as **Administrator**
- Internet connection recommended for DISM RestoreHealth (pulls from Windows Update)

---

## How to Run

1. Right-click `WindowsRepairToolkit.bat`
2. Select **Run as administrator**
3. Select an option from the menu by typing its number and pressing Enter

A log file is created automatically at:
```
%USERPROFILE%\Desktop\WRT_YYYY-MM-DD.log
```

---

## Menu Options

### [1] System File Checker (SFC)
Scans all protected Windows system files and repairs any that are corrupted or missing.  
**Command:** `sfc /scannow`  
**Time:** 5–15 minutes  
**Notes:** Run this after DISM RestoreHealth for best results.

---

### [2] DISM Restore Health
Repairs the Windows component store using Windows Update as a source. Fixes issues that SFC cannot resolve on its own.  
**Command:** `DISM /Online /Cleanup-Image /RestoreHealth`  
**Time:** 10–20 minutes  
**Notes:** Requires an internet connection. Run this before SFC when you suspect deep image corruption.

---

### [3] DISM Scan Health
Scans the Windows component store for corruption without attempting any repairs.  
**Command:** `DISM /Online /Cleanup-Image /ScanHealth`  
**Time:** 5–10 minutes  
**Notes:** Use this as a read-only check before committing to a full RestoreHealth.

---

### [4] Check Disk Errors (C:)
Scans the C: drive for filesystem errors and bad sectors, and attempts to fix them.  
**Command:** `chkdsk C: /f /r /x`  
**Time:** 30–90 minutes (or scheduled for next reboot if C: is in use)  
**Notes:** If Windows is running from C:, the scan cannot run live and will be scheduled for the next boot. You will be prompted to confirm.

---

### [5] Windows Component Cleanup
Removes superseded and unnecessary components from the Windows component store to reclaim disk space.  
**Command:** `DISM /Online /Cleanup-Image /StartComponentCleanup`  
**Time:** 5–15 minutes  
**Notes:** Safe to run on healthy systems. Useful after major Windows updates.

---

### [6] Reset Winsock Network
Resets the Winsock catalog to its default state. Fixes network connectivity issues caused by corrupted socket configurations.  
**Commands:** `netsh winsock reset`, `netsh int ip reset`  
**Time:** Under 1 minute  
**Notes:** A reboot is required for changes to take effect.

---

### [7] Reset TCP/IP
Resets the TCP/IP stack including IPv4 and IPv6 settings to their defaults. Useful when network issues persist after a Winsock reset.  
**Commands:** `netsh int tcp reset`, `netsh int ipv4 reset`, `netsh int ipv6 reset`  
**Time:** Under 1 minute  
**Notes:** A reboot is required for changes to take effect.

---

### [8] Flush DNS Cache
Clears the local DNS resolver cache and re-registers the machine's DNS records with the network.  
**Commands:** `ipconfig /flushdns`, `ipconfig /registerdns`  
**Time:** Under 1 minute  
**Notes:** Useful when websites fail to load or resolve to stale IP addresses.

---

### [9] DISM Check Health
Performs a quick check of the Windows component store to determine whether corruption is present. Does not scan or repair.  
**Command:** `DISM /Online /Cleanup-Image /CheckHealth`  
**Time:** Under 1 minute  
**Notes:** Use this as a fast first step before deciding whether a full scan or repair is needed.

---

### [10] System Information
Displays detailed information about the system including OS version, hardware, network adapters, hotfixes, and more.  
**Command:** `systeminfo`  
**Time:** Under 1 minute  
**Notes:** Output is also saved to the log file.

---

### [11] Run Recommended Repair Sequence
Runs the full recommended repair sequence in order:
1. DISM CheckHealth
2. DISM ScanHealth
3. DISM RestoreHealth
4. System File Checker (SFC)

**Time:** 20–40 minutes  
**Notes:** This is the recommended approach for general Windows repair. Run this when you are unsure which tool to use.

---

### [12] Driver Query
Lists all installed drivers with verbose detail including file path, version, start type, and state.  
**Command:** `driverquery /v`  
**Time:** Under 1 minute  
**Notes:** Output can be large. Scroll up in the terminal or review the log file on your Desktop.

---

### [13] Signed Drivers Info
Lists all installed drivers and indicates whether each one is digitally signed.  
**Command:** `driverquery /si`  
**Time:** Under 1 minute  
**Notes:** Unsigned drivers can cause instability. Use this to identify any unsigned drivers present on the system.

---

### [14] Device Problem Scan
Scans all connected devices and lists any that have driver problems — missing, broken, or misconfigured drivers.  
**Command:** `pnputil /enum-devices /problem`  
**Time:** Under 1 minute  
**Notes:** No output means no driver problems were detected.

---

### [15] Install Missing Drivers
Scans connected hardware and attempts to install any missing drivers using the local driver store and Windows Update.  
**Command:** `pnputil /scan-devices`  
**Time:** 1–5 minutes  
**Notes:** No output means no new drivers were needed.

---

### [16] Scan RAM
Opens the Windows Memory Diagnostic tool to schedule a RAM scan on the next reboot.  
**Command:** `mdsched.exe`  
**Time:** 10–20 minutes (runs during the reboot)  
**Notes:** You will be prompted to restart now or schedule the scan for the next time the machine boots. Results are displayed after the reboot completes.

---

### [0] Exit
Closes the toolkit. The log file path is displayed before exit.

---

## Logging

Every operation is logged to a timestamped file on your Desktop:
```
WRT_YYYY-MM-DD.log
```
Each log entry includes the time the operation ran and its completion status. The log persists after the toolkit is closed.

---

## Recommended Workflow

For general Windows repair, use this sequence:

1. Run **[11] Recommended Repair Sequence** — handles DISM and SFC in the correct order
2. If driver issues are suspected, run **[14] Device Problem Scan** followed by **[15] Install Missing Drivers**
3. For network problems, run **[6] Reset Winsock** or **[7] Reset TCP/IP**, then reboot
4. For memory instability or random crashes, run **[16] Scan RAM**

---

## License

This project is released into the public domain. Use and modify freely.

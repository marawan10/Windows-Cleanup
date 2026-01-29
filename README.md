# ⚡ Windows Cleanup & Programmer Booster

A powerful, all-in-one Windows batch script designed for developers and power users. It cleans system junk, optimizes disk performance, and frees up space by recursively deleting `node_modules`, `build`, and `dist` folders from your project directories.

![Platform](https://img.shields.io/badge/Platform-Windows_10%2F11-0078D6)
![License](https://img.shields.io/badge/License-MIT-green)

## 🚀 Features

### 🧹 System Cleanup
- **Temp Files:** Cleans User Temp, Windows Temp, and Prefetch.
- **Cache:** Clears Windows Update cache, Error Reports, and Delivery Optimization files.
- **Browsers:** Clears caches for Google Chrome and Microsoft Edge.
- **Logs:** Wipes Windows Logs, Setup Logs, and Event Logs.
- **Store:** Resets Microsoft Store cache (`wsreset`).
- **DNS:** Flushes DNS cache.

### 👨‍💻 Developer Tools
- **Project Cleaning:** Optionally scans your projects folder to recursively delete:
  - `node_modules`
  - `build`
  - `dist`
- **Memory:** Forces Garbage Collection to free up RAM.

### 🛠️ Maintenance & Repair
- **Disk Optimization:** Smart detection for SSD (Trim) vs HDD (Defrag).
- **System Repair:** Optional deep scan using `SFC /scannow` and `DISM`.
- **Startup:** Option to disable non-essential startup tasks.

### 📊 Smart Reporting
- Calculates and displays the exact amount of disk space reclaimed (in MB) after cleanup.

## 📥 Installation & Usage

1. **Download:** Download the `Cleanup.bat` file from this repository.
2. **Run:** Right-click the file and select **Run as Administrator** (The script will also attempt to auto-elevate if you forget).
3. **Follow Prompts:** The script will ask for permission before running deep system repairs or deleting developer folders.

## ⚙️ Configuration

By default, the script looks for developer projects in `%UserProfile%\Projects`.
If your projects are in a different location (e.g., `C:\Code` or `D:\Work`), open the script in a text editor and find this line:

```batch
for /d %%P in ("%UserProfile%\Projects\*") do (

# WOLPS

# Wake-on-LAN PowerShell GUI Tool

A lightweight **PowerShell-based GUI** for sending **Wake-on-LAN (WOL)** magic packets to remotely power on devices in your network.  
No third-party modules required — uses only built-in **.NET** and **Windows Forms**.

---

## ✨ Features
- **Simple GUI** — enter a MAC address and click **Send**.
- **Pre-filled defaults**:
  - Broadcast IP: `255.255.255.255`
  - Port: `9` (standard WOL port)
- **MAC address validation** — prevents sending invalid packets.
- **Port validation** — ensures valid UDP port range (1–65535).
- **Status feedback** — success or error messages displayed in the GUI.
- **No installation needed** — just run the `.ps1` file.

---


## 🚀 Usage

1. **Enable Wake-on-LAN** on the target PC:
   - In **BIOS/UEFI** settings.
   - In **Windows Device Manager** → Network Adapter → Power Management → Enable WOL.
2. **Download** the `DS_WOLPS.ps1` script.
3. **Run PowerShell / ISE as Administrator**.
4. Allow script execution for the session:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
   or

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\DS_WOLPS.ps1
   

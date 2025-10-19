# How to Install Docker Desktop on Windows and macOS

This guide provides instructions on how to install Docker Desktop on Windows and macOS. The information is sourced from the official Docker documentation.

---

## Installing Docker Desktop on Windows

### System Requirements

* **OS**: Windows 10 64-bit: Home or Pro 22H2 (build 19045) or higher, or Enterprise or Education 22H2 (build 19045) or higher.
* **WSL**: Enable the WSL 2 feature on Windows.
* **Hardware**:
    * 64-bit processor with Second Level Address Translation (SLAT)
    * 4GB system RAM
    * BIOS-level hardware virtualization support must be enabled.

### Installation Steps

1.  **Download Docker Desktop:**
    * Download the installer from the official Docker website: [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)

2.  **Run the Installer:**
    * Double-click `Docker Desktop Installer.exe` to run the installer.
    * When prompted, ensure the **Use WSL 2 instead of Hyper-V** option on the Configuration page is selected.

3.  **Follow the on-screen instructions** to complete the installation process.

4.  **Start Docker Desktop:**
    * Once the installation is complete, start Docker Desktop from the Windows Start menu.

---

## Installing Docker Desktop on macOS

### System Requirements

* **macOS**: Must be one of the three most recent major versions of macOS.
* **Hardware**:
    * **Intel chip**: Mac with an Intel processor.
    * **Apple silicon**: Mac with an Apple M1 or M2 chip.
    * At least 4 GB of RAM.
    * Rosetta 2 is recommended for Apple silicon Macs. You can install it manually by running:
        ```bash
        softwareupdate --install-rosetta
        ```

### Installation Steps

1.  **Download Docker Desktop:**
    * Download the installer from the official Docker website: [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
    * Choose the correct version for your Mac (Intel or Apple Silicon).

2.  **Install the Application:**
    * Double-click the downloaded `.dmg` file to open the installer.
    * Drag the **Docker** icon to your **Applications** folder.

3.  **Run Docker Desktop:**
    * Open the **Applications** folder and double-click **Docker.app** to start Docker.
    * Accept the Docker Subscription Service Agreement to continue.

4.  **Complete the setup:**
    * Follow the on-screen instructions to finish the configuration. You may be asked for your password to authorize the installation.

---

For more detailed information and troubleshooting, please refer to the official Docker documentation.

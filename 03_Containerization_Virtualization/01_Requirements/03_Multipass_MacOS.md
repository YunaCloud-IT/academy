# How to Install Multipass on macOS

This guide provides simple instructions for installing Multipass, a tool from Canonical that makes it easy to run Ubuntu virtual machines on your Mac.

---

## What is Multipass?

Multipass is a lightweight VM manager for developers. It allows you to get a fresh Ubuntu environment with a single command, making it perfect for testing, development, and running Linux software on your Mac without the overhead of a full virtualization tool like VirtualBox or VMware.

---

## System Requirements

* **macOS**: Version 10.14 (Mojave) or later.
* **Hardware**: A Mac with an Intel or Apple Silicon (M1/M2/M3) processor.
* **RAM**: At least 4GB of RAM is recommended.

---

## Method 1: Using the Official Installer (Recommended)

This is the most straightforward method and ensures you get the latest stable version directly from the developers.

1.  **Download the Installer:**
    * Go to the official Multipass website: [multipass.run](https://multipass.run/)
    * Click the **Download Multipass for macOS** button. This will download a `.pkg` file.



2.  **Run the Installer:**
    * Open the downloaded `.pkg` file from your `Downloads` folder.
    * The installer will launch. Follow the on-screen instructions by clicking **Continue**, **Agree** to the license, and **Install**.

3.  **Enter Your Password:**
    * You will be prompted to enter your Mac's administrator password to authorize the installation.

4.  **Finish Installation:**
    * Once the process is complete, you can close the installer. Multipass is now installed and running in the background. You'll see a new Multipass icon in your menu bar. ✅

---

## Method 2: Using Homebrew

If you're a developer who already uses [Homebrew](https://brew.sh/), you can install Multipass with a single command.

1.  **Open Terminal:**
    * You can find the Terminal app in `Applications/Utilities/` or by searching with Spotlight (⌘ + Space).

2.  **Run the Install Command:**
    * Type the following command and press Enter. This will download and install the Multipass package (cask).

    ```bash
    brew install --cask multipass
    ```

3.  **Wait for Completion:**
    * Homebrew will handle the download and installation process for you. Once the command finishes, Multipass is ready to use.

---

## Verify the Installation

After installing, it's a good idea to make sure everything is working correctly.

1.  **Open a new Terminal window.**

2.  **Check the Version:**
    * Run the following command to see the installed version of Multipass.

    ```bash
    multipass version
    ```

3.  **Launch Your First VM:**
    * Let's launch a test virtual machine named `test-vm`. This command will download the latest Ubuntu LTS image and start the VM.

    ```bash
    multipass launch --name test-vm
    ```

4.  **List Your VMs:**
    * To see your new VM running, use the `list` command.

    ```bash
    multipass list
    ```

    You should see an output similar to this:

    ```
    Name                    State             IPv4             Image
    test-vm                 Running           192.168.64.2     Ubuntu 22.04 LTS
    ```

You're all set! You can now start using Multipass for your development projects. 🚀

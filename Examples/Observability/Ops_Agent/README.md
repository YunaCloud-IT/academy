# Installation of the Ops Agent on a Google Compute Engine

To install the Ops Agent on a Google Compute Engine instance, you can use the command line (SSH/RDP) or the Google Cloud Console.

## 1. Prerequisites (Critical)

Before installing, ensure the Service Account attached to your VM has the following IAM roles. Without these, the agent can install but cannot send data:

- `roles/logging.logWriter` (Logs Writer)

- `roles/monitoring.metricWriter` (Monitoring Metric Writer)

## 2. Installation via Command Line (Recommended)

This is the fastest method for existing VMs.

### For Linux VMs

SSH into your instance and run this single command to add the repo and install the agent:

```Bash
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

### For Windows VMs

RDP into your instance, open a **PowerShell** terminal as Administrator, and run:

```PowerShell
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.ps1", "${env:UserProfile}\add-google-cloud-ops-agent-repo.ps1")
Invoke-Expression "${env:UserProfile}\add-google-cloud-ops-agent-repo.ps1 -AlsoInstall"
```

### 3. Verification

After installation, verify the agent is active.

- Linux:

```Bash
sudo systemctl status google-cloud-ops-agent"*"
```

You should see Active: active (running).

- Windows:

```PowerShell
Get-Service google-cloud-ops-agent
```

Status should be `Running`.

## 4. Alternative: "No-Code" Installation (Console)

If you prefer not to use the command line, you can trigger the installation from the GCP Console.

1. Navigate to **Compute Engine** > **VM instances**.
2. Click on the specific VM name.
3. Click the **Observability** tab.
4. Look for the **Ops Agent** section and click **Install** (or "Install/Update").

- *Note: This relies on the OS Config agent being active on your VM.*


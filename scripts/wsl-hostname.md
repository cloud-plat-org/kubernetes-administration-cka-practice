To make your WSL (Ubuntu) instance keep a custom hostname even after restarting, you need to configure the `/etc/wsl.conf` file and update both `/etc/hostname` and `/etc/hosts`. This prevents WSL from resetting the hostname to match your Windows machine each time it starts.

### Steps for a Permanent WSL Hostname

1. **Edit or Create `/etc/wsl.conf`:**
   ```ini
   [network]
   hostname = your-chosen-hostname
   generateHosts = false
   ```
   Replace `your-chosen-hostname` with the hostname you want.

2. **Edit `/etc/hostname`:**
   Change the file to contain only your new hostname.

3. **Edit `/etc/hosts`:**
   Find the line with your old hostname (usually after `127.0.1.1`) and update it to use your new hostname:
   ```
   127.0.1.1   your-chosen-hostname
   ```

4. **Restart WSL:**
   In PowerShell or CMD, run:
   ```
   wsl --shutdown
   ```
   Then reopen your WSL Ubuntu terminal.

After these steps, your WSL instance should always use your specified hostname after every restart, independently of your Windows machine's name.To keep your WSL (Ubuntu) hostname persistent after restarts, create or edit `/etc/wsl.conf` with the following content:[3][4][5][1]

```
[network]
hostname = your-custom-hostname
generateHosts = false
```

---
title: GitHub authentication: SSH (recommended) and HTTPS (PAT)
---

This document shows two permanent ways to stop GitHub asking for a password when you push:

- SSH keys (recommended) — set up an SSH key in WSL, add the public key to GitHub, switch your repo remote to SSH.
- HTTPS with a Personal Access Token (PAT) — create a PAT and let Git Credential Manager (GCM) store it so you don't re-enter it.

Choose one method below.

## 1) SSH method (recommended)

1. Generate an SSH key (if you don't already have one)

```powershell
ssh-keygen -t ed25519 -C "your-email@example.com"
```

Accept the default file (~/.ssh/id_ed25519) and optionally set a passphrase.

2. Start the ssh-agent and add the key

```powershell
# start the agent
eval $(ssh-agent -s)

# add the key
ssh-add ~/.ssh/id_ed25519
```

3. Copy the public key and add it to GitHub

```powershell
cat ~/.ssh/id_ed25519.pub
```

Copy the output, then open GitHub → Settings → SSH and GPG keys → New SSH key. Paste the key and save.

4. Update your local repo remote to use SSH (run inside your repo)

```powershell
git remote set-url origin git@github.com:cloud-plat-org/kubernetes-administration-cka-practice.git
```

5. Test

```powershell
git fetch
git push -u origin main
```

You should no longer be prompted for a password.

## 2) HTTPS + PAT method (alternative)

1. Create a Personal Access Token (PAT) on GitHub

- Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) or Fine-grained tokens.
- Create a token with at least the `repo` scope for repository access. Copy the token now — you cannot view it later.

2. Install/configure Git Credential Manager Core (GCM) on WSL (Ubuntu example)

Download and install GCM (use the latest release from the GitHub releases page):

```powershell
# example — replace with the latest release URL
wget https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.935/gcm-linux_amd64.2.0.935.deb
sudo dpkg -i gcm-linux_amd64.2.0.935.deb

# configure git to use it
git config --global credential.helper manager-core
```

3. Use the token once

When you `git push` over HTTPS, use your GitHub username and paste the PAT when prompted for a password. GCM will cache the token and you won't be prompted again.

## 3) Remove cached/old credentials

If Git keeps trying the old password, remove cached credentials from Windows Credential Manager or clear the stored credential in GCM:

```powershell
printf "protocol=https\nhost=github.com\n" | git credential-manager-core erase
```

## Notes and next steps

- If you want me to run the SSH setup commands in your WSL terminal and switch the repo remote to SSH, say "Run SSH setup" and I'll execute the commands. I will not add the public key to your GitHub account for you — you must paste it into the GitHub web UI for security.
- If you prefer the PAT route, say "Configure PAT" and I'll guide you through creating the token and configuring GCM.

---

Generated/cleaned-up by tooling — ready to copy or use as a markdown file.

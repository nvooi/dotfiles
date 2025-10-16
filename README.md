# 🛠️ Dotfiles Setup

This repository contains personal dotfiles and a setup process for configuring your development environment on **macOS** and **Debian-based Linux** systems.

The process is split into two parts:

- `bootstrap.sh`: Prepares the system by installing core dependencies (e.g. `git`, `vim`, `zsh`), cloning this repository, and calling the main setup script.
- `install.sh`: The main script that applies your environment configuration, including symlinks, shell setup, and editor configuration.

---

## 🚀 Quick Start

To install your dotfiles on a fresh system, run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nvooi/dotfiles/master/bootstrap.sh)


# SSH Dashboard & Auto-Fix for macOS

A simple, color-coded SSH dashboard and key auto-fix script for macOS using `ssh-agent` and the Keychain.  

Features:

- ✅ Checks if `ssh-agent` is running
- ✅ Validates `SSH_AUTH_SOCK`
- ✅ Lists loaded SSH keys with color-coded status
- ✅ Automatically reloads missing keys into the macOS Keychain
- ✅ Provides a summary at the top for quick glance

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/ssh-dashboard.git ~/ssh-dashboard
```

2. Make it executable

```bash
chmod +x ~/ssh-dashboard/zsh/ssh-status.zsh
```

3. Source the script in your ```.zshrc``` or ```.bashrc```:

```bash
source ~/ssh-dashboard/zsh/ssh-status.zsh
```

4. Reload your shell:

```bash
source ~/.zshrc
```

## Usage

Run the command:

```bash
ssh-status
```

## Notes

* Currently optimized for macOS (--apple-use-keychain integration)
* Linux support possible; remove --apple-use-keychain in ssh-fix
* Designed for Zsh; minor tweaks may be needed for Bash
* Flexible: use as a sourced function, and execuable script, or via SSH config

## Contributing

Contributions, bug reports, and suggestions are welcome. Feel free to open a pull request or issue.

## License

MIT License

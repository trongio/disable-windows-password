# disable-windows-password

One double-click script that stops Windows asking for a password:

1. Turns off "Windows Hello sign-in only" so password sign-in options are available.
2. Stops the password prompt after sleep.
3. Downloads Microsoft's Sysinternals Autologon directly from Microsoft and opens it, so the PC signs in automatically at boot.

## Use

Download `disable-windows-password.cmd`, double-click it and accept the admin prompt. In the Autologon window, check the username, type your password and click **Enable**.

Or paste this into PowerShell:

```powershell
irm https://raw.githubusercontent.com/trongio/disable-windows-password/main/disable-windows-password.cmd -OutFile $env:TEMP\dwp.cmd; Start-Process $env:TEMP\dwp.cmd
```

To undo, run it again and click **Disable** in Autologon.

## Notes

- Anyone with physical access to the PC gets full access.
- On work or school accounts, domain policies may override or block auto-login.
- If the account password changes, run it again with the new password.

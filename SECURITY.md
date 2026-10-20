# Security

Skills run with the same permissions as your agent. This repository installs third-party skills from their original repositories, pinned to reviewed commits.

## Review policy for each pinned commit

- No install-time downloads piped to a shell.
- No instructions that try to override the user or the system.
- Network calls in scripts are listed and justified in `docs/`.

## Reporting

If you find a malicious or unsafe skill, or a problem in the installer, open a private security advisory on GitHub, or an issue marked `security` if the problem is low risk. Pins are removed or reverted first and investigated afterwards.

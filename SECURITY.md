# Security policy

Veil is an early beta and has not received an external security audit. Please use it with non-critical data and keep independent backups when possible.

## Reporting a vulnerability

Please report suspected security vulnerabilities privately through a [GitHub Security Advisory](https://github.com/veil-notes/app/security/advisories/new).

Do not open a public issue, discussion, or pull request for an unpatched vulnerability.

When reporting, include:

- the affected Veil version and build number;
- device model and Android version;
- a clear description of the impact;
- reproducible steps or a proof of concept, when safe;
- any relevant logs with passwords, private keys, tokens, and personal data removed.

We will review reports as soon as practical and coordinate public disclosure after a fix or mitigation is available. Please do not include real private notes or secrets in a report.

## Scope

Security reports are especially valuable for:

- password, vault, biometric, and session-lock flows;
- encryption, key derivation, and encrypted note storage;
- accidental data exposure through logs, backups, exports, or files;
- release artifacts and signing configuration.

For ordinary bugs and feature requests, use [Issues](https://github.com/veil-notes/app/issues).

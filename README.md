# template

Personal collection of reusable templates and configurations.

## Contents

### `bash/`

**`minimum.sh`** — A minimal, production-ready bash script template with:

- Strict mode (`set -Eeuo pipefail`)
- Signal trapping and temp directory cleanup
- Library-driven colour output and logging (sourced from `lib/`)
- Argument parsing (`-h`, `-v`, `-f`, `-p` with usage message)

Use as a starting point for any new bash script:

```bash
cp -r bash my-script
chmod +x my-script/minimum.sh
```

#### `bash/lib/`

| File | Description |
| ---- | ----------- |
| `colours.sh` | 16-colour xterm-256color palette with `NO_COLOR` support |
| `logging.sh` | Timestamped `log_info`/`log_warn`/`log_error` helpers |

### `libvirt/`

KVM/QEMU domain XML configurations for local VMs.

| File | VM | RAM | vCPUs | Key features |
| ---- | --- | --- | ----- | ----------- |
| `fedora.xml` | Fedora | 8 GB | 4 | SPICE + GL, VirtIO, CPU pinning |
| `win11.xml` | Windows 11 | 8 GB | 4 | UEFI, TPM, Hyper-V, CPU pinning |

Define a VM with:

```bash
virsh define libvirt/fedora.xml
virsh define libvirt/win11.xml
```

## Requirements

- **Bash**: Any modern shell (for `bash/` scripts)
- **libvirt + KVM**: `virsh`, `qemu-kvm` (for `libvirt/` configs)

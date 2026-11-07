# Droidspaces LKM for OnePlus 13 (Android 15 / Kernel 6.6)

A KernelSU / APatch / Magisk loadable kernel module (LKM) providing missing namespace and IPC features (`CONFIG_PID_NS`, `CONFIG_IPC_NS`) for **OnePlus 13** and other devices running **Android 15 on Linux Kernel 6.6 GKI**.

Enables running [Droidspaces](https://github.com/ravindu644/Droidspaces-OSS) containers natively on stock kernels **without modifying or flashing `boot.img`**.

---

## The Problem

On stock Android 15 Generic Kernel Images (GKI 6.6):
- `CONFIG_PID_NS` (PID namespaces) is disabled.
- `CONFIG_IPC_NS` (IPC namespaces) is disabled.

When launching Droidspaces or running `droidspaces check`, it reports:
```
[✗] PID namespace
[✗] IPC namespace
[✗] 2 required feature(s) missing - Droidspaces will not work
```

Standard workarounds usually involve unpacking, patching, recompiling, and flashing a custom `boot.img`, which risks bootloops, bricks, or broken OTA/vendor compatibility.

---

## The Solution

This module injects the necessary namespace hooks into RAM dynamically using out-of-tree kernel modules (`droid_lkm.ko` and `droid_lkm_vendor.ko`).

### Features:
- **Zero Partition Writes**: No touching `boot.img`, `init_boot.img`, or any partition.
- **Stock Compatibility**: Keeps your existing kernel, modules, and vendor drivers 100% intact.
- **Automatic Loading**: Boots seamlessly via KernelSU / APatch / Magisk services (`post-fs-data`, `service`, `late-load`).
- **One-Click Action**: Test or inspect module status directly from KernelSU Manager.

---

## Verification

After installing and rebooting (or triggering the action script), run in root terminal:
```bash
droidspaces check
```
Result:
```
[MUST HAVE]
  [✓] Root privileges
  [✓] Linux version
  [✓] PID namespace
  [✓] Mount namespace
  [✓] UTS namespace
  [✓] IPC namespace
  [✓] pivot_root syscall
  [✓] /proc filesystem
  [✓] /sys filesystem
  [✓] Seccomp support

Summary:
  [✓] All required features found!
```

---

## Credits

- **[Dere3046](https://github.com/Dere3046/_patchHarmony)** - Creator of `_patchHarmony` and `droid_lkm`
- **[ravindu644](https://github.com/ravindu644/Droidspaces-OSS)** - Creator of Droidspaces

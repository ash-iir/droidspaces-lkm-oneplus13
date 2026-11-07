#!/system/bin/sh
# KernelSU Manager action: load now and show the tail of the loader log.
MODDIR=${0%/*}
/system/bin/sh "$MODDIR/loader.sh" action
tail -n 20 /data/adb/droidspaces_lkm.log 2>/dev/null

#!/system/bin/sh
MODDIR=${0%/*}
exec /system/bin/sh "$MODDIR/loader.sh" post-fs-data

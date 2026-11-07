#!/system/bin/sh
# Load the Droidspaces LKMs.
# Called by post-fs-data.sh, late-load.sh, service.sh and action.sh.
# Loading is idempotent: an already-present module is skipped.

STAGE="${1:-manual}"
MODDIR=${0%/*}
KODIR="$MODDIR/ko"
LOG=/data/adb/droidspaces_lkm.log
INSMOD=/system/bin/insmod
[ -x "$INSMOD" ] || INSMOD=insmod

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null)] [$STAGE] $*" >> "$LOG"
}

if [ -f "$LOG" ] && [ "$(wc -c < "$LOG" 2>/dev/null | tr -d ' ')" -gt 131072 ]; then
    : > "$LOG"
fi

if [ ! -d "$KODIR" ]; then
    log "skip: $KODIR missing"
    exit 0
fi

KREL="$(uname -r)"
case "$KREL" in
    6.6.*|6.18.21-*|*android15-6.6*) ;;
    *)
        log "warning: unexpected kernel $KREL, attempting to load compatible modules anyway"
        ;;
esac

load() {
    name="$1"
    shift
    if grep -q "^$name " /proc/modules; then
        log "$name already loaded"
        return 0
    fi
    if [ ! -f "$KODIR/$name.ko" ]; then
        log "$name.ko missing (optional)"
        return 0
    fi
    out="$("$INSMOD" "$KODIR/$name.ko" "$@" 2>&1)"
    rc=$?
    if [ "$rc" -eq 0 ]; then
        log "$name loaded"
    else
        log "$name insmod failed rc=$rc: $out"
    fi
    return "$rc"
}

log "start kernel=$KREL"
load droid_lkm
[ -f "$KODIR/droid_lkm_vendor.ko" ] && load droid_lkm_vendor
[ -f "$KODIR/macvlan.ko" ] && load macvlan
[ -f "$KODIR/ip6table_nat.ko" ] && load ip6table_nat
[ -f "$KODIR/droid_lkm_misc.ko" ] && load droid_lkm_misc userns_any=1

loaded=0
for name in droid_lkm droid_lkm_vendor macvlan ip6table_nat droid_lkm_misc; do
    if grep -q "^$name " /proc/modules; then
        loaded=$((loaded + 1))
    fi
done
log "done loaded=$loaded"
exit 0

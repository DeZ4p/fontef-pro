#!/system/bin/sh
# =============================================
# FontEF Pro v1.0
# Author: @DeZ4p | t.me/DeZ4p
# =============================================

MODPATH=${MODPATH:-/data/adb/modules/FontEF_Pro}
METABASE="/data/adb/modules/meta-overlayfs/mnt"
ALL_IDS="fontef fontef_pro FontEF fontef-pro font_ef"

ui_print ""
ui_print " ========================="
ui_print "   FontEF Pro v1.0"
ui_print "   t.me/DeZ4p"
ui_print " ========================="
ui_print ""

ui_print "- Creating directories..."
for DIR in system product system_ext vendor; do
    mkdir -p "$MODPATH/$DIR/fonts"
    mkdir -p "$MODPATH/$DIR/etc"
done
mkdir -p "$MODPATH/webroot"

if [ -d "$METABASE" ]; then
    ui_print "- meta-overlayfs detected"
    METADIR="$METABASE/FontEF_Pro"
    for DIR in system product system_ext vendor; do
        mkdir -p "$METADIR/$DIR/fonts"
    done
fi

ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0755 0644
for DIR in system product system_ext vendor; do
    if [ -d "$MODPATH/$DIR" ]; then
        chmod 755 "$MODPATH/$DIR"
        chmod 755 "$MODPATH/$DIR/fonts" 2>/dev/null
        chmod 755 "$MODPATH/$DIR/etc" 2>/dev/null
    fi
done
if [ -d "$MODPATH/webroot" ]; then
    chmod 755 "$MODPATH/webroot"
    chmod 644 "$MODPATH/webroot/"* 2>/dev/null
fi

for DIR in system product system_ext vendor; do
    if [ -d "$MODPATH/$DIR/fonts" ]; then
        chcon -R u:object_r:system_file:s0 "$MODPATH/$DIR" 2>/dev/null
    fi
done

for OLD in $ALL_IDS; do
    if [ -d "/data/adb/modules/$OLD" ]; then
        ui_print "- Removing old: $OLD"
        rm -rf "/data/adb/modules/$OLD"
    fi
    rm -rf "/data/adb/modules_update/$OLD" 2>/dev/null
    if [ -d "$METABASE/$OLD" ]; then
        rm -rf "$METABASE/$OLD"
    fi
done

FOLDERS="FontEF_Pro fontef_pro fontef FontEF fontef-pro font_ef FontEF_Pro_backup"
SDPATHS="/sdcard /storage/emulated/0 /storage/sdcard0 /storage/sdcard1"
for SD in $SDPATHS; do
    if [ -d "$SD" ]; then
        for F in $FOLDERS; do
            rm -rf "$SD/$F" 2>/dev/null
        done
    fi
done
for F in $FOLDERS; do
    rm -rf "/data/adb/$F" 2>/dev/null
done

rm -f /data/local/tmp/fontef* 2>/dev/null
rm -f /data/local/tmp/FontEF* 2>/dev/null
rm -f /cache/fontef* 2>/dev/null

BRAND=$(getprop ro.product.brand 2>/dev/null)
MODEL=$(getprop ro.product.model 2>/dev/null)
ANDROID=$(getprop ro.build.version.release 2>/dev/null)
KSUD=$(ksud --version 2>/dev/null || echo "unknown")
SDK=$(getprop ro.build.version.sdk 2>/dev/null)

ui_print ""
ui_print "- Device: $BRAND $MODEL"
ui_print "- Android: $ANDROID (SDK $SDK)"
ui_print "- KSU: $KSUD"

if [ -d "$METABASE" ]; then
    ui_print "- Overlay: meta-overlayfs"
elif [ -d "/data/adb/overlay" ]; then
    ui_print "- Overlay: generic"
else
    ui_print "- Overlay: standard mount"
fi

if [ -d "/data/adb/modules/susfs4ksu" ]; then
    ui_print "- SUSFS: detected"
fi

ui_print ""
ui_print "- Installation complete!"
ui_print "- Open KernelSU > Modules"
ui_print "- Tap FontEF Pro > WebUI"
ui_print ""

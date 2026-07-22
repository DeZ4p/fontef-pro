#!/system/bin/sh
# =============================================
# FontEF Pro v1.0
# Author: @DeZ4p | t.me/DeZ4p
# =============================================

MODID="FontEF_Pro"
MODPATH="/data/adb/modules/$MODID"
METABASE="/data/adb/modules/meta-overlayfs/mnt"

# === ALL module names ever used ===
ALL_IDS="FontEF_Pro fontef_pro fontef FontEF fontef-pro font_ef"

# === ALL possible sdcard paths ===
SDPATHS="/sdcard /storage/emulated/0 /storage/sdcard0 /storage/sdcard1 /mnt/sdcard /mnt/media_rw"

# === ALL possible folder names ===
FOLDERS="FontEF_Pro fontef_pro fontef FontEF fontef-pro font_ef FontEF_Pro_backup fontef_pro_backup fontef_backup FontEF_backup"

# === Step 1: Remove module directories ===
for DIR in system product system_ext vendor scripts webroot META-INF; do
    rm -rf "$MODPATH/$DIR" 2>/dev/null
done

# === Step 2: Remove ALL backups from /data ===
for F in $FOLDERS; do
    rm -rf "/data/adb/$F" 2>/dev/null
    rm -rf "/data/$F" 2>/dev/null
    rm -rf "/data/local/tmp/$F" 2>/dev/null
    rm -rf "/cache/$F" 2>/dev/null
done

# === Step 3: Remove ALL from sdcard/storage ===
for SD in $SDPATHS; do
    if [ -d "$SD" ]; then
        for F in $FOLDERS; do
            rm -rf "$SD/$F" 2>/dev/null
        done
    fi
done

# === Step 4: Remove from modules_update ===
for ID in $ALL_IDS; do
    rm -rf "/data/adb/modules_update/$ID" 2>/dev/null
done

# === Step 5: meta-overlayfs cleanup ===
if [ -d "$METABASE" ]; then
    for ID in $ALL_IDS; do
        rm -rf "$METABASE/$ID" 2>/dev/null
    done
fi

# === Step 6: Generic overlay cleanup ===
if [ -d "/data/adb/overlay" ]; then
    for DIR in system product system_ext vendor; do
        rm -rf "/data/adb/overlay/$DIR/fonts" 2>/dev/null
    done
fi

# === Step 7: Restore fonts.xml ===
for FXML in /system/etc/fonts.xml /product/etc/fonts.xml /system_ext/etc/fonts.xml /vendor/etc/fonts.xml; do
    if [ -f "${FXML}.bak" ]; then
        cp -f "${FXML}.bak" "$FXML" 2>/dev/null
        rm -f "${FXML}.bak" 2>/dev/null
    fi
done

# === Step 8: Remove ALL temp files ===
rm -f /data/local/tmp/fontef* 2>/dev/null
rm -f /data/local/tmp/font_ef* 2>/dev/null
rm -f /data/local/tmp/FontEF* 2>/dev/null
rm -f /cache/fontef* 2>/dev/null
rm -f /cache/font_ef* 2>/dev/null
rm -f /cache/FontEF* 2>/dev/null

# === Step 9: Remove old modules ===
for ID in $ALL_IDS; do
    rm -rf "/data/adb/modules/$ID" 2>/dev/null
done

# === Step 10: ksud update ===
if command -v ksud >/dev/null 2>&1; then
    ksud module update 2>/dev/null
fi

# === Step 11: Final cleanup ===
rm -rf "$MODPATH" 2>/dev/null

exit 0

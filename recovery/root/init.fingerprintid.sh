#!sbin/sh

#
# use ro.build.fingerprint,
# use ro.build.version.release, ro.build.version.security_patch, ro.vendor.build.security_patch
# from system/build.prop or vendor/build.prop instead of default.prop
#
# for noAB slot
# for BOARD_BUILD_SYSTEM_ROOT_IMAGE := true or PRODUCT_USE_DYNAMIC_PARTITIONS := true
# for vendor/build.prop
# for keymaster-3.0+
#
# by wzsx150
# v3.1-20200131
#

SYSTEM_TMP=/supersu/system_tmp
VENDOR_TMP=/supersu/vendor_tmp

is_dynamic_partitions=`getprop ro.boot.dynamic_partitions`

if [ "$is_dynamic_partitions" = "true" ]; then

  #systempart
  systempart=/dev/block/mapper/system
  for i in $(seq 0 50)
  do
    [ -e "$systempart" ] && break
    usleep 100000
  done
  [ -e "$systempart" ] || {
    touch /sbin/fingerprint_ready
    setprop "twrp.fingerprintid.prop" "0"
    setprop "twrp.fingerprintid.system" "none"
    exit 1
  }

  #vendorpart
  vendorpart=/dev/block/mapper/vendor
  for i in $(seq 0 200)
  do
    [ -e "$vendorpart" ] && break
    usleep 1000
  done

else

  #systempart
  for i in $(seq 0 90)
  do
    systempart=`find /dev/block -name system | grep "by-name/system" -m 1 2>/dev/null`
    [ -z "$systempart" ] || break
    usleep 100000
  done
  [ -z "$systempart" ] && {
    touch /sbin/fingerprint_ready
    setprop "twrp.fingerprintid.prop" "0"
    setprop "twrp.fingerprintid.system" "none"
    exit 1
  }

  #vendorpart
  for i in $(seq 0 900)
  do
    vendorpart=`find /dev/block -name vendor | grep "by-name/vendor" -m 1 2>/dev/null`
    [ -z "$vendorpart" ] || break
    usleep 1000
  done

fi

mkdir -p "$SYSTEM_TMP"
mkdir -p "$VENDOR_TMP"
mount -t ext4 -o ro "$systempart" "$SYSTEM_TMP"
mount -t ext4 -o ro "$vendorpart" "$VENDOR_TMP"
usleep 100

temp=`cat "$SYSTEM_TMP/system/build.prop" \
          "$SYSTEM_TMP/build.prop" \
          "$VENDOR_TMP/build.prop" \
          /default.prop 2>/dev/null`
usleep 100

umount "$SYSTEM_TMP" &
umount "$VENDOR_TMP" &


# support xiaomi eu
PATCH_real=`echo "$temp" | grep -F "ro.build.version.security_patch_real=" -m 1 | cut -d'=' -f2` && \
PATCH=`echo "$temp" | grep -F "ro.build.version.security_patch=" -m 1 | cut -d'=' -f2` && \
[ -n "$PATCH_real" ] && resetprop "ro.build.version.security_patch" "$PATCH_real" || resetprop "ro.build.version.security_patch" "$PATCH" &

VENPATCH_real=`echo "$temp" | grep -F "ro.vendor.build.security_patch_real=" -m 1 | cut -d'=' -f2` && \
VENPATCH=`echo "$temp" | grep -F "ro.vendor.build.security_patch=" -m 1 | cut -d'=' -f2` && \
[ -n "$VENPATCH_real" ] && resetprop "ro.vendor.build.security_patch" "$VENPATCH_real" || resetprop "ro.vendor.build.security_patch" "$VENPATCH" &

RELEASE=`echo "$temp" | grep -F "ro.build.version.release=" -m 1 | cut -d'=' -f2` && resetprop "ro.build.version.release" "$RELEASE" &
SDK=`echo "$temp" | grep -F "ro.build.version.sdk=" -m 1 | cut -d'=' -f2` && resetprop "ro.build.version.sdk" "$SDK" &

sys_fingerprint_real=`echo "$temp" | grep -F "ro.system.build.fingerprint_real=" -m 1 | cut -d'=' -f2` && \
sys_fingerprint=`echo "$temp" | grep -F "ro.system.build.fingerprint=" -m 1 | cut -d'=' -f2` && \
[ -n "$sys_fingerprint_real" ] && resetprop "ro.system.build.fingerprint" "$sys_fingerprint_real" || resetprop "ro.system.build.fingerprint" "$sys_fingerprint" &

fingerprint=`echo "$temp" | grep -F "ro.build.fingerprint=" -m 1 | cut -d'=' -f2` && resetprop "ro.build.fingerprint" "$fingerprint" &


setprop "twrp.fingerprintid.prop" "1" &
setprop "twrp.fingerprintid.sys_root" "1" &
setprop "twrp.fingerprintid.system" "$systempart" &
setprop "twrp.fingerprintid.vendor" "$vendorpart" &

sleep 1
touch /sbin/fingerprint_ready

sleep 2
sys_fingerprint=`getprop ro.system.build.fingerprint`
RELEASE=`getprop "ro.build.version.release" | cut -d'.' -f1`
[ -n "$sys_fingerprint" -a "$RELEASE" -ge "10" ] && resetprop "ro.build.fingerprint" "$sys_fingerprint"

sleep 2

exit 0





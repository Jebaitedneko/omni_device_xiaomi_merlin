#!sbin/sh

# fix magisk.zip install script
# mount --move /system /system_root will be error on android-10.0

rm_mount() {
  while [ 1 ]
  do
    [ -e /dev/tmp/bin/mount ] && {
      rm -f /dev/tmp/bin/mount
      sleep 2
      return 0
    }
    usleep 10
  done
}


while [ 1 ]
do
  [ -e /dev/tmp ] && rm_mount
  usleep 100
done


if [ -x /usr/bin/update-desktop-database ]; then
  /usr/bin/update-desktop-database -q /usr/share/applications >/dev/null 2>&1
fi
if [ -e usr/share/icons/hicolor/icon-theme.cache ]; then
  if [ -x /usr/bin/gtk-update-icon-cache ]; then
    /usr/bin/gtk-update-icon-cache /usr/share/icons/hicolor >/dev/null 2>&1
  fi
fi
config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
config etc/xdg/autostart/flatpak-autostart.desktop.new
config etc/dbus-1/system.d/org.freedesktop.Flatpak.SystemHelper.conf.new
config etc/profile.d/flatpak.sh.new
flatpak remote-list --system &> /dev/null || :
#Adding Flatpak username and passwd
getent group flatpak >/dev/null || groupadd -r flatpak
getent passwd flatpak >/dev/null || \
useradd -r -g flatpak -d / -s /sbin/nologin \
-c "User for flatpak system helper" flatpak
flatpak remote-list --system &> /dev/null || :
~                                                 

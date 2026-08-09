#!/bin/sh

DEFAULT_ARCH=$(flatpak --default-arch)
THEME_NAME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
THEME_EXTENSION_DIR=$XDG_DATA_HOME/flatpak/extension/org.gtk.Gtk3theme.$THEME_NAME/$DEFAULT_ARCH/3.22

mkdir -p "$THEME_EXTENSION_DIR"

if [ -d "/usr/share/themes/$THEME_NAME/gtk-3.0/" ]; then
      cp -r /usr/share/themes/"$THEME_NAME"/gtk-3.0/* "$THEME_EXTENSION_DIR"
elif [ -d "$XDG_DATA_HOME/themes/$THEME_NAME/gtk-3.0/" ]; then
      cp -r "$XDG_DATA_HOME"/themes/"$THEME_NAME"/gtk-3.0/* "$THEME_EXTENSION_DIR"
else
      echo "Could not find theme files"
      rmdir --ignore-fail-on-non-empty "$THEME_EXTENSION_DIR"
      exit 1
fi

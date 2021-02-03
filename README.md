## AwesomeWM Setup

![](screenshot.png)

Mostly from [Redhound](https://github.com/Purhan/dotfiles/tree/master/RICE/redhound) with some personal modifications.

## Installation

### 1) Install the dependencies

- AwesomeWM
- Rofi
- Compton
- i3lock
- xclip
- maim (for screenshot)
- lxappearance

### 2) Clone the configuration

Run the following commands in the terminal. This also creates a backup for any pre-existing configuration.

```
git clone --depth 1 https://github.com/huytd/awesome-wm-config
cp ~/.config/awesome ~/.config/awesome_backup
mv awesome-wm-config ~/.config/awesome
```

### 3) Set the themes

Start **lxappearance** to active the **icon** theme and **GTK** theme
Note: for cursor theme, edit `~/.icons/default/index.theme` and `~/.config/gtk3-0/settings.ini`, for the change to also show up in applications run as root, copy the 2 files over to their respective place in `/root`.

### 4) Same theme for Qt/KDE applications and GTK applications, and fix missing indicators

First install `qt5-style-plugins` (or `qt5-style-gtk2`) and add this to the bottom of your `/etc/environment`

```bash
XDG_CURRENT_DESKTOP=Unity
QT_QPA_PLATFORMTHEME=gtk2
```

### Wallpapers and Lock Image

Wallpaper and screen lock image are hard-coded to the path at:

```
Wallpaper: $HOME/Pictures/Wallpapers/forest.jpg
Lock Image: $HOME/Pictures/Wallpapers/forest-lock.png
```

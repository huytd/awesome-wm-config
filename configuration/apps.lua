local filesystem = require('gears.filesystem')

local HOME = os.getenv('HOME')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env /usr/bin/rofi -dpi ' .. get_dpi() .. ' -width ' .. with_dpi(400) .. ' -combi-modi window,drun -show combi -modi combi -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'alacritty',
    rofi = rofi_command,
    lock = HOME .. '/.config/awesome/scripts/lock-computer',
    screenshot = 'maim | xclip -selection clipboard -t image/png && notify-send "Screenshot saved to clipboard"',
    region_screenshot = 'maim -s | xclip -selection clipboard -t image/png && notify-send "Screenshot saved to clipboard"',

    -- Editing these also edits the default program
    -- associated with each tag/workspace
    browser = 'env firefox',
    editor = 'goneovim', -- gui text editor
    social = 'env slack',
    game = rofi_command,
    files = 'nautilus',
    music = rofi_command
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'picom --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
    'feh --bg-fill --randomize ~/Pictures/Wallpapers/*',
    'nm-applet --indicator', -- wifi
    'xfce4-power-manager', -- Power manager
    'ibus-daemon --xim --daemonize', -- Ibus daemon for keyboard
    'numlockx on', -- enable numlock
    '/usr/lib/xfce-polkit/xfce-polkit & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'barrier'
  }
}

local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')
require('awful.autofocus')
local beautiful = require('beautiful')
local lgi = require("lgi")

-- Theme
beautiful.init(require('theme'))
local icons = require('theme.icons')
local dpi = require('beautiful').xresources.apply_dpi

-- Layout
require('layout')

-- Init all modules
require('module.notifications')
require('module.auto-start')
require('module.decorate-client')
-- Backdrop causes bugs on some gtk3 applications
--require('module.backdrop')
require('module.exit-screen')

-- Setup all configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))

-- Signal function to execute when a new client appears.
_G.client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Make the focused window have a glowing border
_G.client.connect_signal(
  'focus',
  function(c)
    -- c.border_color = beautiful.border_focus
    c.border_color = '#dedede'
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    -- c.border_color = beautiful.border_normal
    c.border_color = '#dedede'
  end
)

-- Notify when song changed
local Playerctl = lgi.Playerctl
local player = Playerctl.Player{}
local update_player_status = function()
  if player.playback_status == "PLAYING" then
    naughty.notify({
      icon = icons.music,
      icon_size = dpi(24),
      text = player:get_title(),
      ontop = true,
      shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
      end,
    })
  end
end
player.on_metadata = update_player_status
player.on_playback_status = update_player_status
update_player_status()

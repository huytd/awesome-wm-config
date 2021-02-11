local naughty = require('naughty')
local lgi = require("lgi")
local gears = require('gears')
local icons = require('theme.icons')
local dpi = require('beautiful').xresources.apply_dpi
local beautiful = require('beautiful')

-- Notify when song changed
local MusicNotify = function()
  local Playerctl = lgi.Playerctl
  local player = Playerctl.Player{}
  local update_player_status = function()
    local title = player:get_title()
    if player.playback_status == "PLAYING" then
      if title ~= nil then
        naughty.notify({
          icon = icons.music,
          icon_size = dpi(24),
          text = title,
          ontop = true,
          shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
          end,
        })
      end
    end
  end
  player.on_metadata = update_player_status
  player.on_playback_status = update_player_status
  update_player_status()
end

return MusicNotify

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local TagList = require('widget.tag-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

local systray_width = dpi(100);
local systray_height = dpi(28);

local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(dpi(24))
systray:set_forced_height(dpi(24))

local SystrayPanel = function(s, offset)
  local offsetx = 0
  if offset == true then
    offsetx = s.geometry.width - systray_width - dpi(32)
    offsety = s.geometry.y
  end
  local panel =
    wibox(
    {
      ontop = false,
      type = "dock",
      shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, systray_height / 2)
      end,
      screen = s,
      height = systray_height,
      width = systray_width,
      x = s.geometry.x + offsetx,
      y = s.geometry.y  + offsety,
      stretch = false,
      bg = beautiful.primary.hue_900,
      fg = beautiful.fg_normal,
      struts = {
        top = systray_height
      }
    }
  )

  panel:struts(
    {
      top = dpi(0)
    }
  )

  panel:setup {
    layout = wibox.layout.flex.horizontal,
    wibox.container.margin(systray, dpi(5), dpi(5), dpi(5), dpi(5)),
  }

  return panel
end

return SystrayPanel

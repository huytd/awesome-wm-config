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

-- Date Widget
local date_box = wibox.widget.textclock('<span font="Roboto Mono bold 9">%H:%M  %a %m/%d/%Y</span>')
local date_widget = wibox.container.margin(date_box, dpi(8), dpi(8), dpi(8), dpi(8))

local ClockPanel = function(s, offset)
  local panel =
  wibox(
    {
      ontop = false,
      screen = s,
      type = "dock",
      height = dpi(32),
      width = dpi(160),
      x = s.geometry.width / 2 - dpi(80),
      y = dpi(0),
      stretch = false,
      bg = 'transparent',
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(0)
      }
    }
  )

  panel:struts(
    {
      top = dpi(0)
    }
  )

  panel:setup {
    layout = wibox.layout.fixed.horizontal,
    date_widget
  }

  return panel

end

return ClockPanel

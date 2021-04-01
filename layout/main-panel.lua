local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local TaskList = require('widget.task-list')
local TagList = require('widget.tag-list')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

-- Date Widget
local date_box_width = dpi(180)
local date_box = wibox.widget.textclock('<span font="Roboto Mono bold 9">%H:%M  %a %m/%d/%Y</span>')
local date_widget = wibox.container.margin(date_box, dpi(8), dpi(8), dpi(8), dpi(8))
date_box.forced_width = date_box_width

-- Systray
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(dpi(24))
local systray_widget = wibox.container.margin(systray, dpi(8), dpi(0), dpi(8), dpi(8))


-- Render panel

local TopBarPanel = function(s, offset)
  local panel =
    wibox(
    {
      ontop = false,
      screen = s,
      height = dpi(32),
      width = s.geometry.width,
      x = dpi(0),
      y = dpi(0),
      stretch = false,
      bg = beautiful.primary.hue_900,
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

  date_widget.point = {
    x = s.geometry.width / 2 - date_box_width,
    y = dpi(0)
  }

  panel:setup {
    layout = wibox.layout.align.horizontal,
    TaskList(s),
    {
      layout = wibox.layout.manual,
      date_widget,
    },
    TagList(s),
  }

  return panel
end

return TopBarPanel

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local TaskList = require('widget.task-list')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

-- Current Screen Indicator
local CurrentTag = function(s)
  local box = wibox.widget.imagebox()
  s:connect_signal("tag::history::update", function()
    local index = awful.tag.selected(1)
    box.image = index.icon
  end)
  return wibox.container.margin(box, dpi(8), dpi(8), dpi(8), dpi(8))
end

-- Layout Box
local LayoutBox = function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        3,
        function()
          awful.layout.inc(-1)
        end
      ),
      awful.button(
        {},
        4,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        5,
        function()
          awful.layout.inc(-1)
        end
      )
    )
  )
  return layoutBox
end

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
      bg = beautiful.primary.hue_905,
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

  local tagIcon = CurrentTag(s)
  local taskList = TaskList(s)

  panel:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      tagIcon,
      taskList
    },
    {
      layout = wibox.layout.fixed.horizontal,
      nil
    },
    {
      layout = wibox.layout.fixed.horizontal,
      LayoutBox(s)
    }
  }

  return panel
end

return TopBarPanel

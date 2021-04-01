local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')
local apps = require('configuration.apps')

local tags = {
  {
    icon = icons.one,
    type = 'firefox',
    defaultApp = apps.default.browser,
    screen = 1
  },
  {
    icon = icons.two,
    type = 'code',
    defaultApp = apps.default.editor,
    screen = 1
  },
  {
    icon = icons.three,
    type = 'files',
    defaultApp = apps.default.files,
    screen = 1
  },
  {
    icon = icons.four,
    type = 'console',
    defaultApp = apps.default.terminal,
    screen = 1
  },
  {
    icon = icons.five,
    type = 'lab',
    defaultApp = apps.default.terminal,
    screen = 1
  },
}

awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile
}

awful.screen.connect_for_each_screen(
  function(s)
    for i, tag in pairs(tags) do
      awful.tag.add(
        i,
        {
          icon = tag.icon,
          icon_only = true,
          layout = awful.layout.suit.floating,
          gap_single_client = true,
          gap = 0,
          screen = s,
          defaultApp = tag.defaultApp,
          selected = i == 1
        }
      )
    end
  end
)

_G.tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.tile) then
      t.gap = 4
    end
  end
)

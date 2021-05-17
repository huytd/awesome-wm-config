local awful = require('awful')
local left_panel = require('layout.left-panel')
local main_panel = require('layout.main-panel')
local systray_panel = require('layout.systemtray-panel')
local clock_panel = require('layout.clock-panel')

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    if s.index == 1 then
      s.left_panel = left_panel(s)
      s.main_panel = main_panel(s, true)
      s.systray_panel = systray_panel(s, true)
      s.clock_panel = clock_panel(s, true)
    else
      s.main_panel = main_panel(s, false)
      s.systray_panel = systray_panel(s, false)
      s.clock_panel = clock_panel(s, false)
    end
  end
)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      s.main_panel.visible = not fullscreen
      s.systray_panel.visible = not fullscreen
      s.clock_panel.visible = not fullscreen
      if s.left_panel then
        s.left_panel.visible = not fullscreen
      end
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    c.screen.selected_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)

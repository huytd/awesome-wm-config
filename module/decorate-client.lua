local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require("wibox")
local dpi = require('beautiful').xresources.apply_dpi

local function setupTitlebar(c)
  -- Code to create your titlebar here
  local titlebars_enabled = true
  if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
    )

    awful.titlebar(c, {size = dpi(24)}) : setup {
      { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      { -- Middle
        { -- Title
          align  = "center",
          widget = awful.titlebar.widget.titlewidget(c)
        },
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      { -- Right
        awful.titlebar.widget.floatingbutton (c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.ontopbutton    (c),
        awful.titlebar.widget.closebutton    (c),
        layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal
    }
  end
end

local function renderClient(client, mode)
  if client.skip_decoration or (client.rendering_mode == mode) then
    return
  end

  client.rendering_mode = mode
  client.floating = false
  client.maximized = false
  client.above = false
  client.below = false
  client.ontop = false
  client.sticky = false
  client.maximized_horizontal = false
  client.maximized_vertical = false
  -- client.border_width = 3
  client.border_width = 1

  client.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
  end
end

local changesOnScreenCalled = false

local function changesOnScreen(currentScreen)
  local tagIsMax = currentScreen.selected_tag ~= nil and currentScreen.selected_tag.layout == awful.layout.suit.max
  local clientsToManage = {}

  for _, client in pairs(currentScreen.clients) do
    if not client.skip_decoration and not client.hidden then
      table.insert(clientsToManage, client)
    end
  end

  if (tagIsMax or #clientsToManage == 1) then
    currentScreen.client_mode = 'maximized'
  else
    currentScreen.client_mode = 'tiled'
  end

  for _, client in pairs(clientsToManage) do
    renderClient(client, currentScreen.client_mode)
  end
  changesOnScreenCalled = false
end

function clientCallback(client)
  if not changesOnScreenCalled then
    if not client.skip_decoration and client.screen then
      changesOnScreenCalled = true
      local screen = client.screen
      gears.timer.delayed_call(
      function()
        changesOnScreen(screen)
      end
      )
    end
  end
end

function tagCallback(tag)
  if not changesOnScreenCalled then
    if tag.screen then
      changesOnScreenCalled = true
      local screen = tag.screen
      gears.timer.delayed_call(
      function()
        changesOnScreen(screen)
      end
      )
    end
  end
end

_G.client.connect_signal('manage', clientCallback)

_G.client.connect_signal('unmanage', clientCallback)

_G.client.connect_signal('property::hidden', clientCallback)

_G.client.connect_signal('property::minimized', clientCallback)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- _G.client.connect_signal("request::titlebars", setupTitlebar)

_G.client.connect_signal(
'property::fullscreen',
function(c)
  if c.fullscreen then
    renderClient(c, 'maximized')
  else
    clientCallback(c)
  end
end
)

_G.tag.connect_signal('property::selected', tagCallback)

_G.tag.connect_signal('property::layout', tagCallback)


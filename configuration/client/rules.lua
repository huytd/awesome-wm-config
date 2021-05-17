local awful = require('awful')
local gears = require('gears')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      floating = false,
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false
    }
  },

  -- Add titlebars to normal clients and dialogs
  { rule_any = {type = { "normal", "dialog" }
    }, properties = {
      titlebars_enabled = true
    }
  },

  -- Ignore title bar for Alacritty
  -- { rule_any = { name = { "Alacritty" }
    -- }, properties = { titlebars_enabled = false }
  -- },

  -- No decoratio for Conky
  { rule_any = { name = { "conky" }
    }, properties = {
      titlebars_enabled = false,
      skip_decoration = true
    }
  },
}

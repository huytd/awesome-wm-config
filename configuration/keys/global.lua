local awful = require('awful')
require('awful.autofocus')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps = require('configuration.apps')

function poweroff_command()
  awful.spawn.with_shell('poweroff')
  awful.keygrabber.stop(_G.exit_screen_grabber)
end

local function send_key(key)
  root.fake_input('key_press', key)
  os.execute('sleep 0.15')
  root.fake_input('key_release', key)
end

local function send_string_to_client(s, c)
  local old_c = client.focus
  client.focus = c
  for i=1, #s do
    local char = s:sub(i,i)
    root.fake_input('key_press'  , char)
    root.fake_input('key_release', char)
  end
  client.focus = old_c
end

-- Key bindings
local globalKeys =
  awful.util.table.join(
  -- Hotkeys
  awful.key({modkey}, 'F1', hotkeys_popup.show_help, {description = 'show help', group = 'awesome'}),
  -- Tag browsing
  -- awful.key({modkey}, 'w', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  -- awful.key({modkey}, 's', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
  awful.key({modkey}, 'Escape', awful.tag.history.restore, {description = 'go back', group = 'tag'}),
  awful.key({modkey}, 'q',
    function()
      local c = _G.client.focus
      if c then
        c:kill()
      end
    end,
    {description = 'view previous', group = 'tag'}
  ),
  -- arrows
  awful.key(
    {modkey},
    'Left',
    function()
      send_key('Home')
    end,
    {description = 'Super Left as Home', group = 'keyboard'}
  ),
  awful.key(
    {modkey},
    'Right',
    function()
      send_key('End')
    end,
    {description = 'Super Right as End', group = 'keyboard'}
  ),
  -- Main runner
  awful.key(
    {modkey},
    'r',
    function()
      _G.screen.primary.left_panel:toggle(true)
    end,
    {description = 'show main menu', group = 'awesome'}
  ),
  -- Utils
  awful.key(
    {modkey},
    'd',
    function()
      local flag = false
      for _, c in ipairs(mouse.screen.selected_tag:clients()) do
                 if c.minimized == true then
                   flag = true
                 end
                 c.minimized = true
      end
      for _, c in ipairs(mouse.screen.selected_tag:clients()) do
                 if flag == true then
                   c.minimized = false
                 end
      end
    end,
    {description = 'minimize all clients', group = 'awesome'}
  ),
  awful.key(
    {altkey},
    'space',
    function()
      _G.screen.primary.left_panel:toggle(true)
    end,
    {description = 'show main menu', group = 'awesome'}
  ),
  awful.key(
    {altkey},
    'Tab',
    function()
      --awful.client.focus.history.previous()
      awful.client.focus.byidx(1)
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end,
    {description = 'Switch to next window', group = 'client'}
  ),
  awful.key(
    {altkey, 'Shift'},
    'Tab',
    function()
      --awful.client.focus.history.previous()
      awful.client.focus.byidx(-1)
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end,
    {description = 'Switch to previous window', group = 'client'}
  ),
  awful.key(
    {modkey},
    'Tab',
    function()
      awful.spawn.raise_or_spawn('skippy-xd')
    end,
    {description = 'Switch to next window', group = 'client'}
  ),
  -- Programms
  awful.key(
    {'Control', modkey},
    'q',
    function()
      awful.spawn(apps.default.lock)
    end,
    {description = 'Lock the screen', group = 'awesome'}
  ),
  awful.key(
    {'Control', modkey},
    '3',
    function()
      awful.spawn.with_shell(apps.default.screenshot)
    end,
    {description = 'Take a screenshot of your active monitor and copy it to clipboard', group = 'screenshots (clipboard)'}
  ),
  awful.key(
    {'Control', modkey},
    '4',
    function()
      awful.spawn.with_shell(apps.default.region_screenshot)
    end,
    {description = 'Mark an area and screenshot it to your clipboard', group = 'screenshots (clipboard)'}
  ),

  -- Standard program
  awful.key(
    {modkey},
    't',
    function()
      awful.util.spawn_with_shell(apps.default.terminal)
    end,
    {description = 'open a terminal', group = 'launcher'}
  ),
  awful.key({modkey, 'Control'}, 'r', _G.awesome.restart, {description = 'reload awesome', group = 'awesome'}),

  -- Focus window by direction
  awful.key({modkey, 'Shift'}, 'Right',
    function()
      awful.client.focus.bydirection('right')
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end
  ,{description = 'focus window on the right', group = 'client'}),
  awful.key({modkey, 'Shift'}, 'Left',
    function()
      awful.client.focus.bydirection('left')
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end
  ,{description = 'focus window on the left', group = 'client'}),
  awful.key({modkey, 'Shift'}, 'Up',
    function()
      awful.client.focus.bydirection('up')
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end
  ,{description = 'focus window on the up', group = 'client'}),
  awful.key({modkey, 'Shift'}, 'Down',
    function()
      awful.client.focus.bydirection('down')
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end
  ,{description = 'focus window on the down', group = 'client'}),

  -- Move window with Mod + Arrow
  awful.key(
    {modkey}, 'l',
    function()
      local c = _G.client.focus
      if c then
        c:relative_move(20, 0, 0, 0)
      end
    end,
    {description = 'Move window right', group = 'layout'}
  ),
  awful.key(
    {modkey}, 'h',
    function()
      local c = _G.client.focus
      if c then
        c:relative_move(-20, 0, 0, 0)
      end
    end,
    {description = 'Move window left', group = 'layout'}
  ),
  awful.key(
    {modkey}, 'k',
    function()
      local c = _G.client.focus
      if c then
        c:relative_move(0, -20, 0, 0)
      end
    end,
    {description = 'Move window up', group = 'layout'}
  ),
  awful.key(
    {modkey}, 'j',
    function()
      local c = _G.client.focus
      if c then
        c:relative_move(0, 20, 0, 0)
      end
    end,
    {description = 'Move window down', group = 'layout'}
  ),

  -- Resize window with Control + Mod + Arrow
  awful.key(
    {'Control', modkey}, 'l',
    function()
      local c = _G.client.focus
      if c then
        if awful.layout.get(c.screen).name == "floating" or c.floating then
          c:relative_move(0, 0, 40, 0)
        else
          awful.tag.incmwfact(0.05)
        end
      end
    end,
    {description = 'Resize window right', group = 'layout'}
  ),
  awful.key(
    {'Control', modkey}, 'h',
    function()
      local c = _G.client.focus
      if c then
        if awful.layout.get(c.screen).name == "floating" or c.floating then
          c:relative_move(0, 0, -40, 0)
        else
          awful.tag.incmwfact(-0.05)
        end
      end
    end,
    {description = 'Resize window left', group = 'layout'}
  ),
  awful.key(
    {'Control', modkey}, 'k',
    function()
      local c = _G.client.focus
      if c then
        if awful.layout.get(c.screen).name == "floating" or c.floating then
          c:relative_move(0, 0, 0, -40)
        else
          awful.client.incwfact(0.05)
        end
      end
    end,
    {description = 'Resize window up', group = 'layout'}
  ),
  awful.key(
    {'Control', modkey}, 'j',
    function()
      local c = _G.client.focus
      if c then
        if awful.layout.get(c.screen).name == "floating" or c.floating then
          c:relative_move(0, 0, 0, 40)
        else
          awful.client.incwfact(-0.05)
        end
      end
    end,
    {description = 'Resize window down', group = 'layout'}
  ),

  awful.key(
    {modkey, 'Shift'},
    'space',
    function()
      awful.layout.inc(-1)
    end,
    {description = 'select previous', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'n',
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        _G.client.focus = c
        c:raise()
      end
    end,
    {description = 'restore minimized', group = 'client'}
  ),

  -- Brightness
  awful.key(
    {},
    'XF86MonBrightnessUp',
    function()
      awful.spawn('xbacklight -inc 10')
    end,
    {description = '+10%', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86MonBrightnessDown',
    function()
      awful.spawn('xbacklight -dec 10')
    end,
    {description = '-10%', group = 'hotkeys'}
  ),
  -- ALSA volume control
  awful.key(
    {},
    'XF86AudioRaiseVolume',
    function()
      awful.spawn('amixer -D pulse sset Master 5%+')
    end,
    {description = 'volume up', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioLowerVolume',
    function()
      awful.spawn('amixer -D pulse sset Master 5%-')
    end,
    {description = 'volume down', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioMute',
    function()
      awful.spawn('amixer -D pulse set Master 1+ toggle')
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioNext',
    function()
      awful.spawn('playerctl next')
    end,
    {description = 'next song', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioPrev',
    function()
      awful.spawn('playerctl previous')
    end,
    {description = 'previous song', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioPlay',
    function()
      awful.spawn('playerctl play-pause')
    end,
    {description = 'toggle play', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerDown',
    function()
      --
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerOff',
    function()
      _G.exit_screen_show()
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  -- Screen management
  awful.key(
    {modkey},
    'o',
    awful.placement.centered,
    {description = 'move window to next screen', group = 'client'}
  ),
  awful.key(
    {'Control', modkey},
    'space',
    function()
      local f = awful.placement.centered + awful.placement.scale
      f(client.focus, { to_percent = 0.85 })
    end,
    {description = 'move window to next screen', group = 'client'}
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
  local descr_view, descr_toggle, descr_move, descr_toggle_focus
  if i == 1 or i == 9 then
    descr_view = {description = 'view tag #', group = 'tag'}
    descr_toggle = {description = 'toggle tag #', group = 'tag'}
    descr_move = {description = 'move focused client to tag #', group = 'tag'}
    descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'tag'}
  end
  globalKeys =
    awful.util.table.join(
    globalKeys,
    -- View tag only.
    awful.key(
      {modkey},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      descr_view
    ),
    -- Move client to tag.
    awful.key(
      {modkey, 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:move_to_tag(tag)
          end
        end
      end,
      descr_move
    ),
    -- Toggle tag on focused client.
    awful.key(
      {modkey, 'Control', 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:toggle_tag(tag)
          end
        end
      end,
      descr_toggle_focus
    )
  )
end

return globalKeys

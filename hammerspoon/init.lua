function hide_app()
    local thisapp = hs.application.frontmostApplication()
    hs.application.hide(thisapp)
end

-- global variable, toggle between 1/4-size and full-size
windowsize = 1
function resize()
    local thiswindow = hs.window.frontmostWindow()
    local loc = thiswindow:frame()
    local thisscreen = thiswindow:screen()
    local screenrect = thisscreen:frame()

    if windowsize == 0 then
        loc.h = screenrect.h / 2
        loc.w = screenrect.w / 2
    elseif windowsize == 1 then
        loc.h = screenrect.h
        loc.w = screenrect.w
    end
    thiswindow:setFrame(loc, 0.1)
-- Just maximize
--    windowsize = (windowsize + 1) % 2
end

function snap_window(dir)
    local thiswindow = hs.window.frontmostWindow()
    local loc = thiswindow:frame()

    local thisscreen = thiswindow:screen()
    local screenrect = thisscreen:frame()

    if dir == 'left' then
        loc.x = 0
    elseif dir == 'right' then
        loc.x = screenrect.w - loc.w
    elseif dir == 'up' then
        loc.y = 0
    elseif dir == 'down' then
        loc.y = screenrect.h - loc.h
    end
    thiswindow:setFrame(loc, 0.1)
end

function call_app(app_name)
    app = hs.application.find(app_name)
    hs.application.activate(app)
end

local ch = {"cmd", "ctrl"}
local cah = {"cmd", "alt", "ctrl"}
local cahs = {"cmd", "alt", "ctrl", "shift"}

----- Bind keys to commands
--
----- Snap window to edge of screen
-- hs.hotkey.bind(ch, "H", function()
--     snap_window('left')
-- end)
-- hs.hotkey.bind(ch, "J", function()
--     snap_window('down')
-- end)
-- hs.hotkey.bind(ch, "K", function()
--     snap_window('up')
-- end)
-- hs.hotkey.bind(ch, "L", function()
--     snap_window('right')
-- end)
--

-- Stolen from: https://github.com/S1ngS1ng/HammerSpoon/blob/master/init.lua
hs.window.animationDuration = 0

grid = require "hs.grid"
grid.setMargins('0, 0')

screens = {}
local screenwatcher = hs.screen.watcher.new(function()
      screens = hs.screen.allScreens()
  end)
  screenwatcher:start()
-- Set screen grid depending on resolution
  -- TODO: set grid according to pixels
for index,screen in pairs(hs.screen.allScreens()) do
  if screen:frame().w / screen:frame().h > 2 then
    -- 10 * 4 for ultra wide screen
    grid.setGrid('10 * 4', screen)
  else
    if screen:frame().w < screen:frame().h then
      -- 4 * 8 for vertically aligned screen
      grid.setGrid('4 * 8', screen)
    else
      -- 8 * 4 for normal screen
      grid.setGrid('8 * 4', screen)
    end
  end
end
function Cell(x, y, w, h)
  return hs.geometry(x, y, w, h)
end

current = {}
function init()
  current.win = hs.window.focusedWindow()
  current.scr = hs.window.focusedWindow():screen()
end

function current:new()
  init()
  o = {}
  setmetatable(o, self)
  o.window, o.screen = self.win, self.scr
  o.screenGrid = grid.getGrid(self.scr)
  o.windowGrid = grid.get(self.win)
  return o
end

local function throwLeft()
  local this = current:new()
  this.window:moveOneScreenWest()
end

local function throwRight()
  local this = current:new()
  this.window:moveOneScreenEast()
end

local function leftHalf()
  local this = current:new()
  local cell = Cell(0, 0, 0.5 * this.screenGrid.w, this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
  this.window.setShadows(true)
end

local function rightHalf()
  local this = current:new()
  local cell = Cell(0.5 * this.screenGrid.w, 0, 0.5 * this.screenGrid.w, this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
end

local function topHalf()
  local this = current:new()
  local cell = Cell(0, 0, this.screenGrid.w, 0.5 * this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
end

local function bottomHalf()
  local this = current:new()
  local cell = Cell(0, 0.5 * this.screenGrid.h, this.screenGrid.w, 0.5 * this.screenGrid.h)
  grid.set(this.window, cell, this.screen)
end

hs.hotkey.bind(ch, "H", function()
    leftHalf()
end)
hs.hotkey.bind(ch, "J", function()
    bottomHalf()
end)
hs.hotkey.bind(ch, "K", function()
    topHalf()
end)
hs.hotkey.bind(ch, "L", function()
    rightHalf()
end)

hs.hotkey.bind(cah, "H", function() throwLeft() end)
hs.hotkey.bind(cah, "L", function() throwRight() end)

-- Reload hammerspoon config
hs.hotkey.bind(ch,"Q", function () hs.reload() end)

----- Call specific applications
hs.hotkey.bind(ch,"Y", function() call_app("firefox") end)
hs.hotkey.bind(ch,"C", function() call_app("chrome") end)
hs.hotkey.bind(ch,"I", function() call_app("iTerm2") end)
hs.hotkey.bind(ch,"O", function() call_app("MacVim") end)
hs.hotkey.bind(ch,"E", function() call_app("Evernote") end)
hs.hotkey.bind(ch,"F", function() call_app("Finder") end)
hs.hotkey.bind(ch,"P", function() call_app("Preview") end)
hs.hotkey.bind(ch,"Y", function() call_app("Spotify") end)
hs.hotkey.bind(ch,";", function() call_app("Microsoft Outlook") end)
-----

hs.hotkey.bind(ch, "M", function() hide_app() end)
hs.hotkey.bind(ch,"R", function() resize() end)


----- Spotify -----
-- play/pause spotify
hs.hotkey.bind(ch, "Space", function()
    if hs.spotify.isRunning() then
        hs.spotify.playpause()
    end
end)

hs.hotkey.bind(ch, "Right", function()
    if hs.spotify.isRunning() then
        hs.spotify.next()
    end
end)

hs.hotkey.bind(ch, "Left", function()
    if hs.spotify.isRunning() then
        hs.spotify.previous()
    end
end)
-----

----- Volume control ----
hs.hotkey.bind(ch, "=", function()
   local outdev = hs.audiodevice.allOutputDevices()[1]
   local outdev = hs.audiodevice.current()['device']
   outdev:setOutputVolume(outdev:outputVolume() + 6.25)
   hs.alert(string.format("Vol: %.0f / 100", outdev:outputVolume()))
end)

hs.hotkey.bind(ch, "-", function()
   local outdev = hs.audiodevice.allOutputDevices()[1]
   local outdev = hs.audiodevice.current()['device']
   outdev:setOutputVolume(outdev:outputVolume() - 6.25)
   hs.alert(string.format("Vol: %.0f / 100", outdev:outputVolume()))
end)
-----

----- Experimental code -----
function experiment()
    local thisapp = hs.application.frontmostApplication()
    local thiswindow = hs.window.frontmostWindow()
    local thisscreen = thiswindow:screen()
    local screenrect = thisscreen:frame()

    local loc = thiswindow:frame()
end
hs.hotkey.bind(ch, ",", function() experiment() end)
-----

-- hs.alert.show("Hammerspoon config loaded")
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

--- === PomodoroTimer ===
---
--- Pomodoro timer with graphical display and SQLite backing
---
--- Download: [https://TODO]

-- TODO: Add the ability to write to sqlite. Some sample code:
--

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "PomodoroTimer"
obj.version = "1.0"
obj.author = "jondlm@gmail.com <jondlm@gmail.com>"
obj.homepage = "TODO"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- KSheet:init()
--- Method
--- Initialize the spoon
function obj:init()
  self.db = hs.sqlite3.open(os.getenv("HOME") .. "/.hammerspoon/app-stats.db")
  self.mode = "idle" -- idle, working, or resting
  self.logger = hs.logger.new("PomodoroTimer", "debug")
  self.canvas = hs.canvas.new({
    x = 0,
    y = 0,
    w = hs.screen.mainScreen():fullFrame().w,
    h = 5,
  }):show()
  self.timer = hs.timer.new(1, hs.fnutils.partial(self.tick, self)):start()
  self.seconds_elapsed = 0
  self.seconds_by_mode = {
    working = 25 * 60,
    resting = 3 * 60,
  }
  self.colors_by_mode = {
    working = { alpha = 0.75, red = 0.09, green = 0.48, blue = 0.32 },
    resting = { alpha = 0.75, red = 0.58, green = 0.47, blue = 0.86 },
    background = { alpha = 0.5, red = 0.96, green = 0.98, blue = 0.99 },
  }
  self.watcher = hs.screen.watcher.new(function()
    self.canvas:topLeft({x = 0, y = 0})
    self.canvas:size({w = hs.screen.mainScreen():fullFrame().w, h = 5})
    self.canvas:show()
  end):start()

  -- Initialize the database table
  self.db:exec([[
    CREATE TABLE IF NOT EXISTS pomodoros (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      started TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ')),
      completed INTEGER DEFAULT 0
    );
  ]])
end

-- State diagram
--
--   +---------------------------------------------------------------------------------+
--   v                                                                                 |
-- +------+     /-------\     +-----------+     /----------\     +---------+     /----------\
-- | idle | --> | start | --> |  working  | --> | complete | --> | resting | --> | complete |
-- +------+     \-------/     +-----------+     \----------/     +---------+     \----------/
--   ^                          |                                     |
--   |                          |                                     |
--   |                          v                                     |
--   |                        /-----------\                           |
--   +----------------------- | interrupt | <-------------------------+
--                            \-----------/
function obj:toggle()
  if self.mode == "idle" then
    -- Idle -> Start -> Working
    self.mode = "working"
    self.seconds_elapsed = 0
    self.canvas:show()
    self.db:exec("INSERT INTO pomodoros DEFAULT VALUES;")
    hs.alert.show("PomodoroTimer: start")
  elseif self.mode == "working" then
    -- Working -> Interrupt -> Idle
    self.mode = "idle"
    self.canvas:hide()
    self.seconds_elapsed = 0
    hs.alert.show("PomodoroTimer: work interrupted")
  elseif self.mode == "resting" then
    -- Resting -> Interrupt -> Idle
    self.mode = "idle"
    self.canvas:hide()
    self.seconds_elapsed = 0
    hs.alert.show("PomodoroTimer: rest interrupted")
  end
end

function obj:tick()
  if self.mode == "idle" then
    return
  end

  self.seconds_elapsed = self.seconds_elapsed + 1
  complete_ratio = self.seconds_elapsed / self.seconds_by_mode[self.mode]
  self.canvas:replaceElements({
      action = "fill",
      fillColor = self.colors_by_mode['background'],
      frame = { x = "0", y = "0", h = "1", w = "1" },
      type = "rectangle",
  }, {
    action = "fill",
    fillColor = self.colors_by_mode[self.mode],
    frame = { x = "0", y = "0", h = "1", w = tostring(complete_ratio)},
    type = "rectangle",
  })

  if complete_ratio >= 1 then
    if self.mode == "working" then
      -- Working -> Complete -> Resting
      self.mode = "resting"
      self.seconds_elapsed = 0
      self.db:exec("UPDATE pomodoros SET completed = 1 WHERE id = (SELECT id FROM pomodoros ORDER BY id DESC LIMIT 1);")
      hs.alert.show("PomodoroTimer: work complete, time to rest!")
    elseif self.mode == "resting" then
      -- Resting -> Complete -> Idle
      self.mode = "idle"
      self.seconds_elapsed = 0
      self.canvas:hide()
      hs.alert.show("PomodoroTimer: rest complete, toggle the timer to start working again.")
    end
  end
end

--- PomodoroTimer:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for PomodoroTimer
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * toggle - Start/stop the timer
function obj:bindHotkeys(mapping)
  local actions = {
    toggle = hs.fnutils.partial(self.toggle, self),
  }

  hs.spoons.bindHotkeysToSpec(actions, mapping)
end

return obj

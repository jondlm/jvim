--[[
WITH cte_sums (
  app_name,
  seconds_elapsed
) AS (
  SELECT
    app_name,
    cast((julianday (lead(created) OVER (ORDER BY created)) - julianday (created)) * 24 * 60 * 60 AS integer) AS seconds_elapsed
  FROM
    activations
)
SELECT
  app_name,
  sum(seconds_elapsed) total_seconds
FROM
  cte_sums
GROUP BY
  app_name;
--]]

pomodoroTimer = hs.loadSpoon("PomodoroTimer")
pomodoroTimer:bindHotkeys({
  toggle = {{"ctrl", "cmd"}, "p"}
})

-- Utilities

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

local db = hs.sqlite3.open(os.getenv("HOME") .. "/.hammerspoon/app-stats.db")

-- Bootstrap the database tables
db:exec([[
  CREATE TABLE IF NOT EXISTS activations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    app_name TEXT NOT NULL,
    created TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ'))
  );
  ]])

function onAppChange(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated and appName ~= "loginwindow") then
    db:exec("INSERT INTO activations(app_name) VALUES (\"" .. appName .. "\");")

    -- if (appName == "Slack") then
    --   hs.alert.show("Are you really sure you want to use this app?", hs.alert.defaultStyle, hs.screen.mainScreen(), 10)
    -- end
  end
end

appWatcher = hs.application.watcher.new(onAppChange)
appWatcher:start()

local deactivateEvents = Set {
  hs.caffeinate.watcher.screensDidLock,
  hs.caffeinate.watcher.screensDidSleep,
  hs.caffeinate.watcher.systemWillPowerOff
}
function onCaffeinate(eventType)
  if deactivateEvents[eventType] then
    db:exec("INSERT INTO activations(app_name) VALUES (\"Deactivate\");")
  end
end

caffeineWatcher = hs.caffeinate.watcher.new(onCaffeinate)
caffeineWatcher:start()

hs.hotkey.bind({"cmd", "ctrl"}, "R", function() hs.reload() end)

function resize(height)
    local win = hs.window.focusedWindow()
    if win then
        win:setSize(hs.geometry.size(1.6 * height, height))

        local screen = win:screen()  -- Get the screen the window is on
        local max = screen:frame()   -- Get the screen frame dimensions

        -- Calculate the centered frame for the window
        local f = win:frame()
        f.x = (max.w - f.w) / 2 + max.x
        f.y = (max.h - f.h) / 2 + max.y

        win:setFrame(f)  -- Move the window to the centered frame
    else
        hs.alert.show("No active window")
    end
end

-- 16:10, 1.6x
hs.hotkey.bind({"cmd", "ctrl"}, "1", function() resize(400) end)
hs.hotkey.bind({"cmd", "ctrl"}, "2", function() resize(600) end)
hs.hotkey.bind({"cmd", "ctrl"}, "3", function() resize(800) end)
hs.hotkey.bind({"cmd", "ctrl"}, "4", function() resize(1000) end)

hs.alert.show("Config loaded")

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

require "pomodoro"

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
db:exec([[
  CREATE TABLE IF NOT EXISTS pomodoros (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    started TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ')),
    completed INTEGER DEFAULT 0
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

-- Pomodoro timer
runningTimer = nil
breakingTimer = nil

function activateTimer()
  if runningTimer == nil then
    hs.alert.show("Pomodoro started")
    db:exec("INSERT INTO pomodoros DEFAULT VALUES;")
    runningTimer = hs.timer.doAfter(25 * 60, function()
      runningTimer = nil
      db:exec("UPDATE pomodoros SET completed = 1 WHERE id = (SELECT id FROM pomodoros ORDER BY id DESC LIMIT 1);")
      hs.alert.show("Pomodoro finished")
    end)
  else
    remainingSeconds = runningTimer:nextTrigger()
    hs.alert.show("Pomodoro in progress. " .. remainingSeconds / 60 .. " min")
  end
end

hs.hotkey.bind({"cmd", "ctrl"}, "R", function() hs.reload() end)

hs.alert.show("Config loaded")

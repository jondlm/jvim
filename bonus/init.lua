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

hs.alert.show("Config loaded")

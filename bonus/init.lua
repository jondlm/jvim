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

local db = hs.sqlite3.open(os.getenv("HOME") .. "/.hammerspoon/app-stats.db")

-- Bootstrap the database table if it's missing
db:exec([[
  CREATE TABLE IF NOT EXISTS activations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    app_name TEXT NOT NULL,
    created TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ'))
  );
  ]])

function onAppChange(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    db:exec("INSERT INTO activations(app_name) VALUES (\"" .. appName .. "\");")

    if (appName == "Slack") then
      hs.alert.show("Are you really sure you want to use this app?", hs.alert.defaultStyle, hs.screen.mainScreen(), 10)
    end
  end
end

appWatcher = hs.application.watcher.new(onAppChange)
appWatcher:start()

function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

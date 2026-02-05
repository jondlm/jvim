local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

-- Function to generate random alphanumeric string
local function random_string()
  local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  local result = ""
  math.randomseed(os.time() + os.clock() * 1000000)
  for i = 1, 3 do
    local idx = math.random(1, #chars)
    result = result .. chars:sub(idx, idx)
  end
  return result
end

return {
  -- Debug print with random identifier
  s("jdlm", {
    t('print("jdlm-find-'),
    f(function() return random_string() end, {}),
    t('")'),
  }),
}

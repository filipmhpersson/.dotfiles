local M = {}

local state = {
  current = nil,
  timer = nil,
}

local function trim(value)
  return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function run(command, callback)
  vim.system(command, { text = true }, function(result)
    callback(result.code == 0, trim(result.stdout))
  end)
end

local function run_sync(command)
  local result = vim.system(command, { text = true }):wait()
  return result.code == 0, trim(result.stdout)
end

local function detect_tmux_appearance(callback)
  if not vim.env.TMUX or vim.env.TMUX == "" then
    callback(nil)
    return
  end

  run({ "tmux", "show-options", "-gvq", "@appearance" }, function(ok, output)
    if ok and (output == "dark" or output == "light") then
      callback(output)
      return
    end

    callback(nil)
  end)
end

local function detect_macos_appearance(callback)
  if vim.fn.has("mac") == 0 then
    callback("dark")
    return
  end

  run({ "defaults", "read", "-g", "AppleInterfaceStyle" }, function(ok, output)
    callback(ok and output == "Dark" and "dark" or "light")
  end)
end

local function detect_appearance(callback)
  detect_tmux_appearance(function(mode)
    if mode then
      callback(mode)
      return
    end

    detect_macos_appearance(callback)
  end)
end

local function detect_appearance_sync()
  if vim.env.TMUX and vim.env.TMUX ~= "" then
    local ok, output = run_sync({ "tmux", "show-options", "-gvq", "@appearance" })
    if ok and (output == "dark" or output == "light") then
      return output
    end
  end

  if vim.fn.has("mac") == 0 then
    return "dark"
  end

  local ok, output = run_sync({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  return ok and output == "Light" and "light" or "dark"
end

local function refresh_lualine()
  local ok, lualine = pcall(require, "config.lualine")
  if ok and type(lualine.setup) == "function" then
    lualine.setup()
  end
end

local function apply(mode)
  if mode == state.current then
    return
  end

  state.current = mode

  vim.schedule(function()
    local is_light = mode == "light"
    local colorscheme = is_light and "gruvbox-material" or "gruvbox-material"
    vim.o.background = is_light and "dark" or "dark"

    local ok = pcall(vim.cmd.colorscheme, colorscheme)
    if not ok and is_light then
      pcall(vim.cmd.colorscheme, "gruvbox-material")
    end

    refresh_lualine()
  end)
end

function M.setup()
  apply(detect_appearance_sync())

  if state.timer then
    return
  end

  state.timer = vim.uv.new_timer()
  state.timer:start(
    0,
    2000,
    vim.schedule_wrap(function()
      detect_appearance(apply)
    end)
  )

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if state.timer and not state.timer:is_closing() then
        state.timer:stop()
        state.timer:close()
      end
    end,
  })
end

return M

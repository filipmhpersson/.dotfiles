-- lua/plugins/lualine.lua
-- Lualine config using vim.pack + GitHub Dark Dimmed colorscheme

local M = {}

local function hex(n)
	if type(n) ~= "number" then
		return nil
	end
	return string.format("#%06x", n)
end

local function brighten(hex, percent)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)

	local function clamp(x)
		return math.max(0, math.min(255, x))
	end

	r = clamp(r + (255 - r) * percent)
	g = clamp(g + (255 - g) * percent)
	b = clamp(b + (255 - b) * percent)

	return string.format("#%02x%02x%02x", r, g, b)
end

local function hl(name)
	-- link=true so we follow links and get real colors
	local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
	if not ok or type(h) ~= "table" then
		return {}
	end
	return h
end

local function fg(name)
	return hex(hl(name).fg)
end
local function bg(name)
	return hex(hl(name).bg)
end

function M.setup()
	vim.pack.add({
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
		{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	})

	require("nvim-web-devicons").setup({
		default = true,
	})

	local transparentbg = nil

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local mode_map = {
		["NORMAL"] = "N",
		["O-PENDING"] = "N?",
		["INSERT"] = "I",
		["VISUAL"] = "V",
		["V-BLOCK"] = "VB",
		["V-LINE"] = "VL",
		["V-REPLACE"] = "VR",
		["REPLACE"] = "R",
		["COMMAND"] = "!",
		["SHELL"] = "SH",
		["TERMINAL"] = "T",
		["EX"] = "X",
		["S-BLOCK"] = "SB",
		["S-LINE"] = "SL",
		["SELECT"] = "S",
		["CONFIRM"] = "Y?",
		["MORE"] = "M",
	}

	-- Pull “theme-correct” colors from highlight groups
	local colors = {
		normal_fg = fg("Normal") or "#cdd9e5",
		normal_bg = bg("Normal") or "#22272e",

		comment = fg("Comment") or "#768390",
		keyword = fg("Keyword") or "#539bf5",
		string = fg("String") or "#57ab5a",

		diag_err = fg("DiagnosticError") or "#ff7b72",
		diag_warn = fg("DiagnosticWarn") or "#d29922",
		diag_info = fg("DiagnosticInfo") or "#539bf5",
		diag_hint = fg("DiagnosticHint") or "#bc8cff",

		diff_add = fg("DiffAdd") or fg("Added") or "#57ab5a",
		diff_del = fg("DiffDelete") or fg("Removed") or "#ff7b72",
	}
	local normal_bg = bg("Normal") or "#22272e"
	local tinted_bg = brighten(normal_bg, 0.08) -- 8% brighter

	local config = {
		options = {
			component_separators = "",
			section_separators = "",
			options = {
				component_separators = "",
				section_separators = "",
				theme = {
					normal = {
						c = {
							fg = fg("Normal") or "#cdd9e5",
							bg = tinted_bg,
						},
					},
					inactive = {
						c = {
							fg = fg("Comment") or "#768390",
							bg = normal_bg,
						},
					},
				},
			},
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			lualine_c = {},
			lualine_x = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			lualine_c = {},
			lualine_x = {},
		},
	}

	local function ins_left(component)
		table.insert(config.sections.lualine_c, component)
	end

	local function ins_right(component)
		table.insert(config.sections.lualine_x, component)
	end

	ins_left({
		"branch",
		cond = conditions.check_git_workspace,
		icon = "",
		color = { fg = colors.keyword, gui = "bold" },
	})

	ins_left({
		"filename",
		cond = conditions.buffer_not_empty,
		color = { fg = colors.normal_fg, gui = "bold" },
	})
	-- ins_left({
	-- 	function()
	-- 		local cur = vim.api.nvim_get_current_buf()
	-- 		local names = {}
	--
	-- 		local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
	--
	-- 		for _, b in ipairs(vim.api.nvim_list_bufs()) do
	-- 			if b ~= cur and vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
	-- 				local full = vim.api.nvim_buf_get_name(b)
	-- 				local base = (full == "" and "[No Name]") or vim.fn.fnamemodify(full, ":t")
	--
	-- 				local label = base
	-- 				if ok_devicons and full ~= "" then
	-- 					local ext = vim.fn.fnamemodify(base, ":e")
	-- 					local icon = devicons.get_icon(base, ext, { default = true })
	-- 					if icon and icon ~= "" then
	-- 						label = icon .. " " .. base
	-- 					end
	-- 				end
	--
	-- 				table.insert(names, label)
	-- 			end
	-- 		end
	--
	-- 		if #names == 0 then
	-- 			return ""
	-- 		end
	--
	-- 		return table.concat(names, "  ")
	-- 	end,
	-- 	color = { fg = colors.comment, gui = "italic" },
	-- })
	-- Right

	ins_right({
		"diagnostics",
		sources = { "nvim_diagnostic" },
		always_visible = true,
		sections = { "error", "warn", "hint" },
		symbols = { error = "", warn = "", info = "", hint = "" },
		diagnostics_color = {
			error = { fg = colors.diag_err },
			warn = { fg = colors.diag_warn },
			info = { fg = colors.diag_info },
			hint = { fg = colors.diag_hint },
		},
	})
	ins_right({
		"lsp",
		sources = { "" },
	})

	ins_right({
		function()
			local msg = "No Active Lsp"
			local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return msg
			end
			local lsp_short_names = {
				pyright = "py",
				tsserver = "ts",
				rust_analyzer = "rs",
				lua_ls = "lua",
				clangd = "c++",
				bashls = "sh",
				jsonls = "json",
				html = "html",
				cssls = "css",
				tailwindcss = "tw",
				dockerls = "docker",
				sqlls = "sql",
				yamlls = "yml",
			}
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return lsp_short_names[client.name] or client.name:sub(1, 2)
				end
			end
			return msg
		end,
		icon = " ",
		color = {
			fg = colors.YELLOW,
			gui = "bold",
		},
	})

	-- ins_right({
	-- 	function()
	-- 		return "▊"
	-- 	end,
	-- 	color = { fg = colors.normal_fg },
	-- 	padding = { left = 1 },
	-- })

	require("lualine").setup(config)
end

return M

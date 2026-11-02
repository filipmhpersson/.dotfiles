-- Neovim config for VS Code (vscode-neovim).
-- Mirrors the LSP / search keymaps from ~/.config/nvim, but routes them to VS Code commands.
if not vim.g.vscode then
  return
end

local vscode = require("vscode")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local function action(name, opts)
  return function()
    vscode.action(name, opts)
  end
end

-- General (same as plugin/keymaps.fnl) ---------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "J", "mzJ`z")
map("n", "n", "nzzzv", "Next result and center")
map("n", "N", "Nzzzv", "Prev result and center")
-- Needs the ctrl+d / ctrl+u entries in VS Code's keybindings.json, which send the keys to Neovim
map({ "n", "x" }, "<C-d>", "<C-d>zz", "Half page down + center")
map({ "n", "x" }, "<C-u>", "<C-u>zz", "Half page up + center")
map({ "n", "v" }, "<leader>y", '"+y', "Yank to system clipboard")
map("x", "<leader>p", '"_dP', "Paste and keep register")

map("n", "<C-h>", action("workbench.action.navigateLeft"))
map("n", "<C-j>", action("workbench.action.navigateDown"))
map("n", "<C-k>", action("workbench.action.navigateUp"))
map("n", "<C-l>", action("workbench.action.navigateRight"))

-- Jumplist ----------------------------------------------------------------
-- vscode-neovim maps <C-o>/<C-i> to VS Code's navigateBack/Forward, which records every big cursor
-- move and edit, and Neovim's own jumplist can't follow jumps across VS Code editors. So keep our own:
-- every jump mapping below records where it came from, and <C-o>/<C-i> walk that list.
local jumps, jump_pos = {}, 1 -- jump_pos == #jumps + 1 means "at the newest location"

local function current_location()
  local ok, loc = pcall(vscode.eval, [[
    const editor = vscode.window.activeTextEditor;
    if (!editor) return null;
    const p = editor.selection.active;
    return { uri: editor.document.uri.toString(), line: p.line, character: p.character };
  ]], {}, 1000)
  if ok and type(loc) == "table" then
    return loc
  end
end

local function goto_location(loc)
  vscode.eval_async([[
    const pos = new vscode.Position(args.line, args.character);
    await vscode.window.showTextDocument(vscode.Uri.parse(args.uri), { selection: new vscode.Range(pos, pos) });
  ]], { args = loc })
end

local function push_jump()
  local loc = current_location()
  if not loc then
    return
  end
  for i = #jumps, jump_pos, -1 do
    table.remove(jumps, i)
  end
  local last = jumps[#jumps]
  if not (last and last.uri == loc.uri and last.line == loc.line) then
    table.insert(jumps, loc)
  end
  if #jumps > 100 then
    table.remove(jumps, 1)
  end
  jump_pos = #jumps + 1
end

map("n", "<C-o>", function()
  local target = jump_pos - vim.v.count1
  if target < 1 then
    return
  end
  if jump_pos == #jumps + 1 then
    -- Remember where we left from, so <C-i> can come back here
    local loc = current_location()
    if loc then
      table.insert(jumps, loc)
    end
  end
  jump_pos = target
  goto_location(jumps[jump_pos])
end, "Jump back")

map("n", "<C-i>", function()
  local target = jump_pos + vim.v.count1
  if target > #jumps then
    return
  end
  jump_pos = target
  goto_location(jumps[jump_pos])
end, "Jump forward")

-- Like action(), but records the current location in the jumplist first
local function jump_action(name, opts)
  return function()
    push_jump()
    vscode.action(name, opts)
  end
end

-- LSP navigation (same keys as after/plugin/lsp_attach.fnl + nvim defaults)
map("n", "gd", jump_action("editor.action.revealDefinition"), "Goto definition")
map("n", "grr", jump_action("editor.action.goToReferences"), "Goto references")
map("n", "gri", jump_action("editor.action.goToImplementation"), "Goto implementation")
map("n", "grt", jump_action("editor.action.goToTypeDefinition"), "Goto type definition")
map("n", "grn", action("editor.action.rename"), "Rename symbol")
map({ "n", "x" }, "gra", action("editor.action.quickFix"), "Code action")
map("n", "gO", jump_action("workbench.action.gotoSymbol"), "Document symbols")
map("n", "K", action("editor.action.showHover"), "Hover")
map("n", "[d", jump_action("editor.action.marker.prev"), "Prev diagnostic")
map("n", "]d", jump_action("editor.action.marker.next"), "Next diagnostic")
map("n", "<leader>q", action("workbench.actions.view.problems"), "Diagnostics list")

-- Search (same keys as lua/config/fzflua.lua) ---------------------------
map("n", "<leader>sf", jump_action("workbench.action.quickOpen"), "[S]earch [F]iles")
map("n", "<leader>sg", jump_action("workbench.action.quickTextSearch"), "[S]earch by [G]rep")
map("n", "<leader>sG", jump_action("workbench.action.findInFiles"), "[S]earch by [G]rep (sidebar)")
map("n", "<leader>sw", function()
  push_jump()
  vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end, "[S]earch current [W]ord")
map("x", "<leader>sw", jump_action("workbench.action.findInFiles"), "[S]earch selection")
map("n", "<leader>sr", action("workbench.view.search"), "[S]earch [R]esume")
map("n", "<leader>sd", action("workbench.actions.view.problems"), "[S]earch [D]iagnostics")
map("n", "<leader>ss", action("workbench.action.showCommands"), "[S]earch [S]elect command")
map("n", "<leader>sk", action("workbench.action.openGlobalKeybindings"), "[S]earch [K]eymaps")
map("n", "<leader>s.", action("workbench.action.openRecent"), "[S]earch recent")
map("n", "<leader>sc", function()
  vim.cmd.edit(vim.fn.resolve(vim.fn.expand("~/.config/nvim-vscode/init.lua")))
end, "[S]earch [C]onfig")
map("n", "<leader><leader>", jump_action("workbench.action.showAllEditorsByMostRecentlyUsed"), "Find open editors")

-- Misc equivalents --------------------------------------------------------
map("n", "-", action("workbench.files.action.showActiveFileInExplorer"), "Reveal file (oil)")
map("n", "<leader>gs", action("workbench.view.scm"), "Git status")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("hl-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

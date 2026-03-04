-------------------------------------------------------------------------------
-- Plugins (lazy.nvim)
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- UI & appearance
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "airblade/vim-gitgutter" },
  { "junegunn/goyo.vim" },

  -- Navigation & search
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" }, lazy = false },
  { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "easymotion/vim-easymotion" },
  { "terryma/vim-expand-region" },
  { "andymass/vim-matchup" },

  -- Coding tools
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = false },
  { "tpope/vim-fugitive" },
  { "tpope/vim-surround" },
  { "spf13/vim-autoclose" },
  { "godlygeek/tabular" },
  { "mattn/emmet-vim" },
  { "editorconfig/editorconfig-vim" },
  { "scrooloose/nerdcommenter" },
  { "vimwiki/vimwiki" },
  { "wuelnerdotexe/vim-astro" },
  { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
  { "neovim/nvim-lspconfig" },
  { "mfussenegger/nvim-lint" },
  { "stevearc/conform.nvim" },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
})

-------------------------------------------------------------------------------
-- Configs
-------------------------------------------------------------------------------

----------------------------------------
-- Diagnostics
----------------------------------------
vim.diagnostic.config({
  virtual_text = true,  -- Show errors inline
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.HINT] = "➤",
      [vim.diagnostic.severity.INFO] = "ℹ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { -- <leader>e
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

----------------------------------------
-- LSP
----------------------------------------

-- Rust
vim.lsp.config.rust_analyzer = {}
vim.lsp.enable('rust_analyzer')

-- TypeScript/JavaScript
vim.lsp.config.ts_ls = {}
vim.lsp.enable('ts_ls')

-- Go
vim.lsp.config.gopls = {}
vim.lsp.enable('gopls')

-- Ruby (Sorbet)
vim.lsp.config.sorbet = {}
vim.lsp.enable('sorbet')

----------------------------------------
-- Treesitter
----------------------------------------
local treesitter = require('nvim-treesitter')
treesitter.install {
  'rust',
  'ruby',
  'javascript',
  'typescript',
  'jsx',
  'tsx',
  'nu',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'ruby',
    'nu',
    'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
    'rust',
  },
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldlevel = 99
  end
})

----------------------------------------
-- Linting
----------------------------------------
local lint = require('lint')
lint.linters_by_ft = {
  markdown = {'vale'},
  ruby = {'rubocop'},
  javascript = {'eslint_d'},
  typescript = {'eslint_d'},
  typescriptreact = {'eslint_d'},
}

-- Trigger linting on these events
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})

----------------------------------------
-- Fixing
----------------------------------------
local conform = require("conform")

-- Returns formatters based on current directory
-- Uses eslint_d in ~/thatch-health, prettier everywhere else
local function js_formatters()
  local cwd = vim.fn.getcwd()
  local thatch_path = vim.fn.expand("~/thatch-health")
  if cwd:find(thatch_path, 1, true) == 1 then
    return { "eslint_d" }
  end
  return { "prettier" }
end

conform.setup({
  formatters_by_ft = {
    rust = { "rustfmt" },

    astro = { "prettier" },
    ruby = { "rubocop" },
    javascript = js_formatters,
    javascriptreact = js_formatters,
    typescript = js_formatters,
    typescriptreact = js_formatters,
    html = { "prettier" },
    go = { "gofmt" },
    elm = { "elm_format" },
    scala = { "scalafmt" },
    python = { "ruff_format" },
    php = { "php_cs_fixer" },
  },
  -- Format on save (can be disabled per-buffer with vim.b.disable_autoformat)
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat then
      return
    end
    return {
      timeout_ms = 2500,
      lsp_fallback = true,
    }
  end,
})

----------------------------------------
-- Lualine
----------------------------------------
local lualine = require("lualine")
lualine.setup()

----------------------------------------
-- Catppuccin
----------------------------------------
local catppuccin = require("catppuccin")

-- Track current flavour
vim.g.catppuccin_flavour = "frappe"

catppuccin.setup({
  flavour = vim.g.catppuccin_flavour,
  custom_highlights = function(colors)
    return {
      -- Git gutter signs
      GitGutterAdd = { fg = colors.green },
      GitGutterChange = { fg = colors.yellow },
      GitGutterDelete = { fg = colors.red },
      GitGutterChangeDelete = { fg = colors.peach },
    }
  end,
})

-- Toggle between frappe and latte
function toggle_catppuccin()
  if vim.g.catppuccin_flavour == "frappe" then
    vim.g.catppuccin_flavour = "latte"
  else
    vim.g.catppuccin_flavour = "frappe"
  end
  vim.cmd("Catppuccin " .. vim.g.catppuccin_flavour)
  vim.notify("Catppuccin: " .. vim.g.catppuccin_flavour)
end

----------------------------------------
-- Fzf
----------------------------------------
local fzf = require("fzf-lua")
fzf.setup({
  winopts = {
    height = 0.90,
    width = 0.90,
    preview = {
      layout = "vertical", -- Better for narrow screens
    },
  },
})

----------------------------------------
-- Neo-tree
----------------------------------------
local nt = require("neo-tree")
nt.setup({
  window = {
    mappings = {
      ["/"] = "none",
      ["zz"] = function() vim.cmd("normal! zz") end,
      ["zt"] = function() vim.cmd("normal! zt") end,
      ["zb"] = function() vim.cmd("normal! zb") end,
    },
  },
  filesystem = {
    filtered_items = {
      visible = true, -- Shows hidden files by default, like NERDTree
    },
  },
})

----------------------------------------
-- Completion & Snippets
----------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load custom snippets from luasnippets directory
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/luasnippets" })

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-------------------------------------------------------------------------------
-- Core settings
-------------------------------------------------------------------------------
local opt = vim.opt

vim.g.mapleader = " "

opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.number = true
opt.cursorline = true
opt.termguicolors = true
opt.list = true
opt.listchars = {
  tab = '» ',     -- Show tabs as »
  trail = '·',    -- Show trailing spaces as dots
  nbsp = '␣',     -- Show non-breaking spaces
  extends = '→',  -- Symbol for text extending off-screen (right)
  precedes = '←', -- Symbol for text extending off-screen (left)
}

-- Tabs & Indentation
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Windows & Splits
opt.splitright = true
opt.splitbelow = true
opt.winminheight = 0

-- Performance & Behavior
opt.hidden = true
opt.wrap = false
opt.scrolloff = 3
opt.history = 1000
opt.mouse = "a"
opt.directory = vim.fn.stdpath("cache") .. "/swap//"

-- Colorscheme
vim.cmd([[colorscheme catppuccin]])

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
-- Strip Trailing Whitespace
local function strip_trailing_whitespace()
  local save_cursor = vim.fn.getpos(".")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
end

vim.api.nvim_create_user_command('StripTrailingWhitespace', strip_trailing_whitespace, {})

-- I'm still on the fence about this implementation of AI functionality. It
-- "works" but definitely leaves a lot to be desired.
local function ai_location()
  vim.ui.input({ prompt = "AI Query: " }, function(query)
    if not query or query == "" then return end

    -- Prepend current file location so the agent knows where we are
    local location = vim.fn.expand('%:.') .. ':' .. vim.fn.line('.')
    query = "[Location: " .. location .. "] " .. query

    -- Create a scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = "markdown"

    -- Calculate floating window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
      title = " AI: " .. query:sub(1, 60) .. " ",
      title_pos = "center",
    })

    -- Seed the buffer with a loading line
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Running agent..." })

    -- Close with q or <Esc>
    vim.keymap.set("n", "q", function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end, { buffer = buf })
    vim.keymap.set("n", "<Esc>", function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end, { buffer = buf })

    -- Run agent asynchronously and stream output into the buffer
    local lines = { "" }
    vim.fn.jobstart({ "agent", "--print", "--model", "composer-1.5", query }, {
      stdout_buffered = false,
      stdin = "null",
      on_stdout = function(_, data)
        if not data then return end
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(buf) then return end
          for i, chunk in ipairs(data) do
            if i == 1 then
              -- Append to the last line
              lines[#lines] = lines[#lines] .. chunk
            else
              -- New line
              table.insert(lines, chunk)
            end
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          -- Scroll to bottom
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_cursor(win, { #lines, 0 })
          end
        end)
      end,
      on_stderr = function(_, data)
        if not data then return end
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(buf) then return end
          for i, chunk in ipairs(data) do
            if i == 1 then
              lines[#lines] = lines[#lines] .. chunk
            else
              table.insert(lines, chunk)
            end
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        end)
      end,
      on_exit = function(_, code)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(buf) then return end
          table.insert(lines, "")
          table.insert(lines, "--- agent exited with code " .. code .. " ---")
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        end)
      end,
    })
  end)
end

local function copy_location()
  local path = vim.fn.expand('%:.')
  local line = vim.fn.line('.')
  local result = path .. ':' .. line

  -- Copy to clipboard
  vim.fn.setreg('+', result)

  vim.notify('Copied: ' .. result)
end

local function get_rails_test_path()
  local path = vim.fn.expand('%:.')
  local test_path = path

  -- If we're in a test file, use it directly
  -- Otherwise, convert app path to test path following Rails conventions
  if not path:match('^test/') then
    -- Handle app/ files -> test/ files
    if path:match('^app/') then
      test_path = path:gsub('^app/', 'test/')
                      :gsub('/([^/]+)%.rb$', '/%1_test.rb')
    -- Handle lib/ files -> test/lib/ files
    elseif path:match('^lib/') then
      test_path = path:gsub('^lib/', 'test/lib/')
                      :gsub('%.rb$', '_test.rb')
    else
      return nil
    end
  end

  return test_path
end

local function get_rails_source_path()
  local path = vim.fn.expand('%:.')

  if not path:match('^test/') then
    return nil
  end

  -- Handle test/lib/ files -> lib/ files
  if path:match('^test/lib/') then
    return path:gsub('^test/lib/', 'lib/')
               :gsub('_test%.rb$', '.rb')
  end

  -- Handle test/ files -> app/ files
  return path:gsub('^test/', 'app/')
             :gsub('_test%.rb$', '.rb')
end

local function copy_rails_test_command()
  local test_path = get_rails_test_path()

  if not test_path then
    local path = vim.fn.expand('%:.')
    vim.notify('Cannot determine test file for: ' .. path, vim.log.levels.WARN)
    return
  end

  local command = 'bin/rails test ' .. test_path
  vim.fn.setreg('+', command)
  vim.notify('Copied: ' .. command)
end

local function open_rails_test()
  local path = vim.fn.expand('%:.')

  -- If we're in a test file, go back to the source file
  if path:match('^test/') then
    local source_path = get_rails_source_path()
    if source_path then
      vim.cmd('edit ' .. source_path)
    else
      vim.notify('Cannot determine source file for: ' .. path, vim.log.levels.WARN)
    end
    return
  end

  -- Otherwise, go to the test file
  local test_path = get_rails_test_path()

  if not test_path then
    vim.notify('Cannot determine test file for: ' .. path, vim.log.levels.WARN)
    return
  end

  vim.cmd('edit ' .. test_path)
end

local function copy_github_url()
  local file = vim.fn.expand('%')
  local line = vim.fn.line('.')
  local git_url = vim.fn.system('git-url'):gsub('%s+$', '')
  local commit_hash = vim.fn.system('git rev-parse HEAD'):gsub('%s+$', '')
  local url = string.format('%s/blob/%s/%s#L%s', git_url, commit_hash, file, line)
  vim.fn.setreg('+', url)
  vim.notify('Copied: ' .. url)
end

local function toggle_dianostics_current_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
  vim.diagnostic.enable(not enabled, { bufnr = bufnr })
  vim.notify("Diagnostics " .. (enabled and "disabled" or "enabled") .. " for buffer")
end

local function toggle_format_current_buffer()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify("Format on save " .. (vim.b.disable_autoformat and "disabled" or "enabled") .. " for buffer")
end

local function conform_format()
  conform.format({ async = true, lsp_fallback = true })
end

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------
local keymap = vim.keymap.set

-- Pane Navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Tab Navigation
keymap("n", "H", ":tabprev<CR>")
keymap("n", "L", ":tabnext<CR>")

-- Visual Shifting (Stay in visual mode)
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Neotree
keymap("n", "<C-e>", ":Neotree toggle<CR>")
keymap("n", "<leader>e", ":Neotree reveal<CR>")

-- Conform
keymap("n", "<leader>f", conform_format, { desc = "Format buffer" })

-- Clear Highlights
keymap("n", "<leader>n", ":noh<CR>")

-- [a] AI
keymap("n", "<leader>al", ai_location, { desc = "AI location: ask agent a question" })

-- [c] Clipboard stuff
keymap("n", "<leader>cl", copy_location)
keymap("n", "<leader>ct", copy_rails_test_command)
keymap("n", "<leader>cg", copy_github_url, { desc = "Open in GitHub" })

-- [o] Open
keymap("n", "<leader>ot", open_rails_test)

-- [s] Search stuff
keymap("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/]])
keymap("n", "<leader>sc", "/^\\(<<<<<<<\\|=======\\|>>>>>>>\\)<CR>", { desc = "Search for git conflict markers" })

-- [g] Git
keymap("n", "<leader>g", ":Git<CR>")
keymap("n", "<leader>gr", ":GitGutterUndoHunk<CR>")
keymap("n", "<leader>gb", ":Git blame<CR>")
keymap("n", "<leader>gh", ":Gvsplit HEAD:%<CR>", { desc = "Open file at HEAD in vsplit" })
keymap("n", "<leader>gu", ":Git checkout HEAD -- %<CR>", { desc = "Reset current file to HEAD" })
keymap("n", "]h", ":GitGutterNextHunk<CR>")
keymap("n", "[h", ":GitGutterPrevHunk<CR>")

-- [f] Fzf
keymap("n", "<C-p>", fzf.git_files)
keymap("n", "<C-b>", fzf.buffers)
keymap("n", "<leader>fg", fzf.live_grep)
keymap("n", "<leader>fm", fzf.marks)
keymap("n", "<leader>fr", fzf.resume)
keymap("n", "<leader>ft", fzf.treesitter)
keymap("n", "<leader>fw", fzf.grep_cword)
keymap("n", "<leader>;", fzf.command_history)
keymap("n", "<leader>/", fzf.search_history)

-- [d] Diagnostics (replaces ALE keymaps)
keymap("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic error" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- [l] LSP
keymap("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Show hover info" })
keymap("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap("n", "<leader>lr", vim.lsp.buf.references, { desc = "Show references" })
keymap("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code actions" })

-- [t] Toggle
keymap("n", "<leader>tc", toggle_catppuccin, { desc = "Toggle Catppuccin frappe/latte" })
keymap("n", "<leader>td", toggle_dianostics_current_buffer, { desc = "Toggle diagnostics for current buffer" })
keymap("n", "<leader>tf", toggle_format_current_buffer, { desc = "Toggle format on save for current buffer" })

-------------------------------------------------------------------------------
-- Auto commands (hooks)
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {
    "*.js", "*.ts", "*.tsx",
    "*.go",
    "*.py",
    "*.php"
  },
  callback = strip_trailing_whitespace,
})

-------------------------------------------------------------------------------
-- After file
-------------------------------------------------------------------------------
local after_file = vim.fn.expand("~/.config/nvim/after.lua")
if vim.fn.filereadable(after_file) == 1 then
    dofile(after_file)
end

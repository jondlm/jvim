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
conform.setup({
  formatters_by_ft = {
    rust = { "rustfmt" },

    astro = { "prettier" },
    ruby = { "rubocop" },
    -- eslint_d may need to be installed globally as some projects may not have
    -- it in node_modules, but it will work with the local eslint setup.
    -- Prettier is the fallback when eslint_d fails (e.g. not available).
    javascript = { "eslint_d", "prettier" },
    javascriptreact = { "eslint_d", "prettier" },
    typescript = { "eslint_d", "prettier" },
    typescriptreact = { "eslint_d", "prettier" },
    html = { "prettier" },
    go = { "gofmt" },
    elm = { "elm_format" },
    scala = { "scalafmt" },
    python = { "ruff_format" },
    php = { "php_cs_fixer" },
  },
  -- Format on save
  format_on_save = {
    timeout_ms = 2500,
    lsp_fallback = true,
  },
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
catppuccin.setup({
  flavour = "frappe",
})

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
    ["/"] = "none",      -- Use native search (or change to "fuzzy_finder")
    ["zz"] = function()  -- Ensure zz centers the screen
      vim.cmd("normal! zz")
    end,
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
  local test_path = get_rails_test_path()

  if not test_path then
    local path = vim.fn.expand('%:.')
    vim.notify('Cannot determine test file for: ' .. path, vim.log.levels.WARN)
    return
  end

  vim.cmd('edit ' .. test_path)
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

-- [a] AI
keymap("n", "<leader>al", ai_location, { desc = "AI location: ask agent a question" })

-- Clipboard stuff
keymap("n", "<leader>cl", copy_location)
keymap("n", "<leader>ct", copy_rails_test_command)
keymap("n", "<leader>ot", open_rails_test)

-- Search stuff
keymap("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/]])
keymap("n", "<leader>sc", "/^\\(<<<<<<<\\|=======\\|>>>>>>>\\)<CR>", { desc = "Search for git conflict markers" })

-- Neotree
keymap("n", "<C-e>", ":Neotree toggle<CR>")
keymap("n", "<leader>e", ":Neotree reveal<CR>")

-- Clear Highlights
keymap("n", "<leader>n", ":noh<CR>")

-- [g] Git
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
keymap("n", "<leader>ft", fzf.treesitter)
keymap("n", "<leader>fw", fzf.grep_cword)
keymap("n", "<leader>;", fzf.command_history)
keymap("n", "<leader>/", fzf.search_history)

-- Diagnostics (replaces ALE keymaps)
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

-- Conform
vim.keymap.set({ "n" }, "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

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

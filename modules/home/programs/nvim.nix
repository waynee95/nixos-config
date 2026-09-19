{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    # dependencies for nvim plugins
    gcc
    tree-sitter
    git
    ripgrep
    fd
    lazygit
    fzf
    # language servers, linters + formatters
    nixd
    lua-language-server
    bash-language-server
    pyright
    ruff # ruff lsp + ruff formatter
    typescript-language-server
    svelte-language-server
    prettierd
    nixfmt
    stylua
    shfmt
    elan # lean toolchain manager
  ];

  home.shellAliases = {
    vim = "nvim";
    vi = "nvim";
  };

  home.file.".config/nvim/init.lua".text = ''
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
        return
      end
    end
    vim.opt.rtp:prepend(lazypath)

    vim.opt.title = true
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.colorcolumn = "81"
    vim.opt.wrap = false
    vim.opt.showmatch = true
    vim.opt.autoindent = true
    vim.opt.incsearch = true
    vim.opt.hlsearch = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.scrolloff = 5
    vim.opt.sidescrolloff = 5
    vim.opt.splitbelow = true
    vim.opt.splitright = true
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
    vim.opt.clipboard = "unnamedplus"
    vim.opt.swapfile = false
    vim.opt.mouse = "a"
    vim.opt.termguicolors = true

    -- set leader key to space
    local map = vim.keymap.set
    vim.g.mapleader = " "

    -- clear search highlight on enter
    map("n", "<CR>", ":nohlsearch<CR><CR>")

    -- window navigation 
    map("n", "<C-h>", "<C-w><C-h>", { desc = "Go to left window" })
    map("n", "<C-j>", "<C-w><C-j>", { desc = "Go to lower window" })
    map("n", "<C-k>", "<C-w><C-k>", { desc = "Go to upper window" })
    map("n", "<C-l>", "<C-w><C-l>", { desc = "Go to right window" })

    -- buffer navigation
    map("n", "<C-N>", ":bnext<CR>", { desc = "Next buffer" })
    map("n", "<C-P>", ":bprev<CR>", { desc = "Previous buffer" })

    -- paste over a visual selection without clobbering the clipboard
    vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

    -- open Neogit
    map("n", "<leader>g", ":Neogit<CR>", { desc = "Open Neogit" })

    -- oil file explorer
    map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil" })

    -- snacks pickers
    map("n", "<leader>f", function() Snacks.picker.files() end, { desc = "Find file" })
    map("n", "<leader>s", function() Snacks.picker.grep() end, { desc = "Search text" })
    map("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Pick buffer" })

    -- lsp keymaps
    map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    map("n", "gr", vim.lsp.buf.references, { desc = "Show References" })
    map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
    map("n", "<leader>dp", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
    map("n", "<leader>dn", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })

    -- colorscheme
    vim.cmd.colorscheme("habamax")
    vim.opt.termguicolors = true

    -- lean.nvim: `require("lean").setup()` is deprecated, configure via vim.g.lean_config
    -- see https://github.com/Julian/lean.nvim (activates automatically on Lean files)
    vim.g.lean_config = {
      mappings = true,
      infoview = { autoopen = true },
    }

    -- setup lazy.nvim
    require("lazy").setup({
      spec = {
        { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

        { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

        { "nvim-tree/nvim-web-devicons", lazy = true },

        { "nvim-lua/plenary.nvim", lazy = true },

        {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate",
          event = { "BufReadPost", "BufNewFile" },
          config = function()
            require("nvim-treesitter").setup()
            require("nvim-treesitter").install({
              "nix", "lua", "bash", "python", "markdown", "markdown_inline",
              "json", "yaml", "vim", "vimdoc", "regex",
              "html", "css", "javascript", "typescript", "svelte",
            })
            vim.api.nvim_create_autocmd("FileType", {
              callback = function() pcall(vim.treesitter.start) end,
            })
          end,
        },

        {
          "neovim/nvim-lspconfig",
          event = { "BufReadPost", "BufNewFile", "BufEnter" },
          config = function()
            -- see https://github.com/neovim/nvim-lspconfig/issues/3693
            vim.lsp.enable({ "nixd", "lua_ls", "bashls", "pyright", "ruff", "ts_ls", "svelte" })
          end,
        },

        -- auto-completion
        {
          "saghen/blink.cmp",
          version = "1.*",
          event = "InsertEnter",
          opts = {
            keymap = { preset = "default" },
            sources = { default = { "lsp", "path", "buffer" } },
            completion = { documentation = { auto_show = true } },
          },
        },

        -- Github copilot
        {
          "zbirenbaum/copilot.lua",
          event = "InsertEnter",
          opts = {
            suggestion = {
              enabled = true,
              auto_trigger = true,
              keymap = {
                accept = "<M-l>",
                accept_word = "<M-j>",
                next = "<M-n>",
                prev = "<M-p>",
                dismiss = "<C-e>",
              },
            },
            panel = { enabled = false },
            server = {
              type = "binary",
              custom_server_filepath = "${pkgs.copilot-language-server}/bin/copilot-language-server",
            },
          },
        },

        -- formatting 
        {
          "stevearc/conform.nvim",
          event = "BufWritePre",
          opts = {
            format_on_save = { timeout_ms = 1000 },
            formatters_by_ft = {
              nix = { "nixfmt" },
              lua = { "stylua" },
              sh = { "shfmt" },
              bash = { "shfmt" },
              typescript = { "prettierd" },
              typescriptreact = { "prettierd" },
              svelte = { "prettierd" },
              javascript = { "prettierd" },
              javascriptreact = { "prettierd" },
              json = { "prettierd" },
              python = { "ruff_format", "ruff_organize_imports" },
            },
          },
        },

        -- lean4.nvim (auto-activates on Lean files via vim.g.lean_config above)
        {
          "Julian/lean.nvim",
          event = { "BufReadPre *.lean", "BufNewFile *.lean" },
        },

        -- neogit
        {
          "NeogitOrg/neogit",
          dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
          },
          config = true,
        },

        -- diffview
        {
          "sindrets/diffview.nvim",
          cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
          keys = { { "q", "<cmd>DiffviewClose<CR>", desc = "Close diffview" } },
        },

        -- oil (file explorer)
        {
          "stevearc/oil.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          cmd = { "Oil" },
          keys = { { "-", "<cmd>Oil<CR>", desc = "Open parent directory" } },
          opts = {},
        },

        -- bufferline: display buffers as tabs 
        {
          "akinsho/bufferline.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          event = "VeryLazy",
          opts = {
            options = {
              numbers = "none",
              show_close_icon = false,
              show_buffer_close_icons = false,
              separator_style = "thin",
            },
          },
        },

        -- snacks
        {
          "folke/snacks.nvim",
          priority = 1000,
          lazy = false,
          opts = {
            bigfile = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            explorer = { enabled = false },
          },
        },
      },
      checker = { enabled = false },
    })
  '';
}

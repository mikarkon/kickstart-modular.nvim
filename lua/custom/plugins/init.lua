-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
local version = '0.7.6'
return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function() vim.fn['mkdp#util#install']() end,
    init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
    ft = { 'markdown' },
  },
  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = 'zathura'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    lazy = true, -- lazy load on event
    event = 'BufReadPre',
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false, -- Enable multiwindow support.
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
  {
    'mbbill/undotree',
    lazy = false, -- load on startup or set to true with cmd lazy load
    config = function() vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>', { noremap = true, silent = true }) end,
  },
  {
    'theprimeagen/harpoon',
    lazy = true,
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('harpoon'):setup() end,
    keys = {
      {
        '<leader>A',
        function() require('harpoon'):list():add() end,
        desc = 'harpoon file',
      },
      {
        '<leader>a',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'harpoon quick menu',
      },
      {
        '<C-1>',
        function() require('harpoon'):list():select(1) end,
        desc = 'harpoon to file 1',
      },
      {
        '<C-2>',
        function() require('harpoon'):list():select(2) end,
        desc = 'harpoon to file 2',
      },
      {
        '<C-3>',
        function() require('harpoon'):list():select(3) end,
        desc = 'harpoon to file 3',
      },
      {
        '<C-4>',
        function() require('harpoon'):list():select(4) end,
        desc = 'harpoon to file 4',
      },
      {
        '<C-5>',
        function() require('harpoon'):list():select(5) end,
        desc = 'harpoon to file 5',
      },
    },
  },
  {
    'AstroNvim/astrolsp',
    dependencies = {
      {
        'TypeFox/yang-lsp',
        tag = 'v' .. version,
        build = function(plugin)
          local archive = plugin.dir .. '/server.zip'
          local url = ('https://github.com/TypeFox/yang-lsp/releases/download/v%s/' .. 'yang-language-server_diagram-extension_%s.zip'):format(version, version)

          local function run(cmd)
            local output = vim.fn.system(cmd)
            assert(vim.v.shell_error == 0, output)
          end

          run { 'curl', '-fL', '--retry', '3', '-o', archive, url }
          run { 'unzip', '-oq', archive, '-d', plugin.dir .. '/server' }
          vim.fn.delete(archive)
        end,
      },
    },
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      table.insert(opts.servers, 'yang_lsp')

      local dir = require('lazy.core.config').plugins['yang-lsp'].dir

      opts.config = opts.config or {}
      opts.config.yang_lsp = {
        cmd = {
          ('%s/server/yang-language-server-%s/bin/yang-language-server'):format(dir, version),
        },
        on_init = function(client) client.server_capabilities.semanticTokensProvider = nil end,
      }
    end,
  },
}

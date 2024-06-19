return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        border = true,
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        layout_strategy = 'horizontal',
        layout_config = {
          height = vim.api.nvim_win_get_height(0),
          width = vim.api.nvim_win_get_width(0),
          prompt_position = 'bottom',
          preview_width = 0.6,
          horizontal = {
            prompt_position = 'bottom',
          },
        },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    -- Telescope live_grep in git root
    -- Function to find the git root directory based on the current buffer's path
    local function find_git_root()
      -- Use the current buffer's path as the starting point for the git search
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      -- If the buffer is not associated with a file, return nil
      if current_file == '' then
        current_dir = cwd
      else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      -- Find the Git root directory from the current file's path
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
    end

    -- Custom live_grep function to search in git root
    local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        require('telescope.builtin').live_grep {
          search_dirs = { git_root },
        }
      end
    end

    -- vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = '#1d2021' })
    -- vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = '#1d2021' })
    -- vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = '#1d2021' })
    -- vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = '#1d2021' })
    -- vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = '#1d2021', fg = '#5E81AC' })

    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
    require('telescope').load_extension 'harpoon'
  end,
}

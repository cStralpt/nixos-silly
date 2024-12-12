{ pkgs, inputs, ... }:
let
  finecmdline = pkgs.vimUtils.buildVimPlugin {
    name = "fine-cmdline";
    src = inputs.fine-cmdline;
  };
in
{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      
      extraPackages = with pkgs; [
        # Existing LSP servers
        lua-language-server
        gopls
        xclip
        wl-clipboard
        ripgrep
        fd
        luajitPackages.lua-lsp
        nil
        rust-analyzer
        yaml-language-server
        pyright
        marksman

        # Web development tools
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages."@tailwindcss/language-server"
        nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
        prettierd # Formatter
        eslint_d # Linter
      ];

      plugins = with pkgs.vimPlugins; [
        # LazyVim core
        lazy-nvim
        LazyVim
        plenary-nvim
        telescope-nvim
        nvim-treesitter.withAllGrammars
        nvim-lspconfig
        mason-nvim
        mason-lspconfig-nvim
        none-ls-nvim
        nvim-cmp
        friendly-snippets
        mini-nvim
        neodev-nvim
        which-key-nvim
        dressing-nvim
        nvim-web-devicons

        # Your existing plugins
        finecmdline
        bufferline-nvim
        lualine-nvim
        nvim-surround
        todo-comments-nvim
        telescope-fzf-native-nvim
        vim-tmux-navigator

        # Additional plugins for web development
        typescript-nvim
        nvim-ts-autotag # Auto close/rename HTML tags
        tailwindcss-colors-nvim
      ];

      extraConfig = ''
        set noemoji
        nnoremap : <cmd>FineCmdline<CR>
      '';

      extraLuaConfig = ''
        -- Bootstrap LazyVim
        require("lazyvim.config.options")
        require("lazyvim.config.keymaps")
        require("lazyvim.config.autocmds")

        -- Load LazyVim with your customizations
        require("lazy").setup({
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            
            -- Web Development
            { import = "lazyvim.plugins.extras.lang.typescript" },
            { import = "lazyvim.plugins.extras.lang.json" },
            { import = "lazyvim.plugins.extras.formatting.prettier" },
            { import = "lazyvim.plugins.extras.linting.eslint" },
            { import = "lazyvim.plugins.extras.lang.tailwind" },
            { import = "lazyvim.plugins.extras.lang.html" },
            
            -- React/React Native
            { import = "lazyvim.plugins.extras.lang.jsx" },
            
            -- Editor Enhancements
            { import = "lazyvim.plugins.extras.coding.copilot" },
            { import = "lazyvim.plugins.extras.editor.symbols-outline" },
            { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
            
            -- Testing & Debugging
            { import = "lazyvim.plugins.extras.test.core" },
            { import = "lazyvim.plugins.extras.dap.core" },
            
            -- Import your existing plugin configs
            { import = "./nvim/plugins" },
          },
          defaults = {
            lazy = false,
            version = false,
          },
          install = { colorscheme = { "tokyonight", "catppuccin" } },
        })

        -- LSP Configurations
        local lspconfig = require('lspconfig')

        -- TypeScript/JavaScript
        lspconfig.tsserver.setup({
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              }
            }
          }
        })

        -- HTML
        lspconfig.html.setup{}

        -- CSS
        lspconfig.cssls.setup{}

        -- Tailwind CSS
        lspconfig.tailwindcss.setup{}

        -- Configure none-ls for formatting
        local null_ls = require("null-ls")
        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.eslint_d,
            null_ls.builtins.diagnostics.eslint_d,
          },
        })

        -- Enable auto-formatting on save
        vim.cmd [[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js,*.css,*.scss,*.json,*.html EslintFixAll]]

        -- Your existing configurations
        ${builtins.readFile ./nvim/options.lua}
        ${builtins.readFile ./nvim/keymaps.lua}
        ${builtins.readFile ./nvim/plugins/fine-cmdline.lua}

        -- Setup remaining components
        require("bufferline").setup{}
        require("lualine").setup({
          icons_enabled = true,
        })

        -- Setup TypeScript
        require("typescript").setup({
          server = {
            on_attach = function(client, bufnr)
              -- Enable inlay hints
              vim.lsp.inlay_hint(bufnr, true)
            end,
          }
        })

        -- Setup nvim-ts-autotag for JSX/TSX
        require('nvim-ts-autotag').setup()

        -- Setup Tailwind CSS colors
        require('tailwindcss-colors').setup()
      '';
    };
  };
}

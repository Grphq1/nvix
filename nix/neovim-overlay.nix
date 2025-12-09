# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Fix the broken vue-language-server package
  fixed-vue-language-server = pkgs.vue-language-server.overrideAttrs (oldAttrs: {
    preInstall = ''
      # the mv commands are workaround for https://github.com/pnpm/pnpm/issues/8307
      mv packages packages.dontpruneme
      CI=true pnpm prune --prod
      find packages.dontpruneme/**/node_modules -xtype l -delete
      mv packages.dontpruneme packages

      find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +

      # FIX: Don't delete all symlinks - only delete broken ones
      # The original command breaks @volar/language-server dependency resolution
      # find node_modules packages/language-server/node_modules -xtype l -delete

      # Instead, only remove broken symlinks (pointing to non-existent targets)
      find node_modules packages/language-server/node_modules -xtype l 2>/dev/null | while read link; do
        if [ ! -e "$link" ]; then
          rm -f "$link"
        fi
      done

      # remove non-deterministic files
      rm -f node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
    '';

    meta =
      oldAttrs.meta
      // {
        description = "Official Vue.js language server (fixed for pnpm workspace dependencies)";
      };
  });

  # Use this to create a plugin from a flake input
  # mkNvimPlugin = src: pname:
  #   pkgs.vimUtils.buildVimPlugin {
  #     inherit pname src;
  #     version = src.lastModifiedDate;
  #   };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter-parsers.vue
    nvim-treesitter-parsers.typescript
    nvim-treesitter-parsers.javascript
    nvim-treesitter-parsers.css
    nvim-treesitter-parsers.scss
    nvim-treesitter-parsers.json
    nvim-treesitter-parsers.html
    nvim-treesitter-parsers.lua
    nvim-treesitter-parsers.tsx
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    # nvim-cmp (autocompletion) and extensions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    # ^ nvim-cmp extensions
    # git integration plugins
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    nvim-tree-lua
    bufferline-nvim
    # ^ UI
    # language support
    # ^ language support
    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    nvim-bufdel
    # ^ navigation/editing enhancement plugins
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    trouble-nvim
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim
    # colorscheme
    jellybeans-nvim
    github-nvim-theme
    # Formatters
    conform-nvim
    # ^ Formatters
    vim-wakatime

    # ai
    avante-nvim
    copilot-vim
  ];

  extraPackages = with pkgs; [
    ripgrep
    # language servers
    lua-language-server
    nil
    typescript-language-server
    fixed-vue-language-server # Using fixed version
    typescript
    tailwindcss-language-server
    (pkgs.stdenv.mkDerivation rec {
      pname = "unocss-language-server";
      version = "0.1.8";

      src = pkgs.fetchFromGitHub {
        owner = "xna00";
        repo = "unocss-language-server";
        rev = "v${version}";
        hash = "sha256-rRi9JvjljvjBbY6UsH2YzAQcp+Z+MqxK7hhDNkpEANw=";
      };

      pnpmDeps = pkgs.pnpm.fetchDeps {
        inherit pname version src;
        fetcherVersion = 1;
        hash = "sha256-LYsalGuxSHWiEKg3saYhREkSwEr2UaWE71V0qo8Xjzc=";
      };

      nativeBuildInputs = with pkgs; [
        nodejs
        pnpm.configHook
        makeBinaryWrapper
      ];

      buildPhase = ''
        runHook preBuild
        pnpm run build
        runHook postBuild
      '';

      preInstall = ''
        # the mv commands are workaround for https://github.com/pnpm/pnpm/issues/8307
        mv node_modules node_modules.dontpruneme
        CI=true pnpm prune --prod
        mv node_modules.dontpruneme node_modules

        find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +

        # https://github.com/pnpm/pnpm/issues/3645
        find node_modules -xtype l -delete

        # remove non-deterministic files
        rm -f node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,lib/unocss-language-server}
        cp -r {node_modules,out,bin} $out/lib/unocss-language-server/

        makeWrapper ${pkgs.lib.getExe pkgs.nodejs} $out/bin/unocss-language-server \
          --inherit-argv0 \
          --add-flags $out/lib/unocss-language-server/bin/index.js

        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "A language server for UnoCSS";
        homepage = "https://github.com/xna00/unocss-language-server";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
        mainProgram = "unocss-language-server";
      };
    })
    # formatter/linter
    vscode-langservers-extracted
    eslint
    nodePackages.prettier
    stylua
    alejandra
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    environmentVariables = {
      VUE_TSDK = "${pkgs.typescript}/lib/node_modules/typescript/lib";
      VUE_TYPESCRIPT_PLUGIN = "${fixed-vue-language-server}/lib/language-tools/node_modules/.pnpm/node_modules/@vue/language-server";
    };
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
    environmentVariables = {
      VUE_TSDK = "${pkgs.typescript}/lib/node_modules/typescript/lib";
      VUE_TYPESCRIPT_PLUGIN = "${fixed-vue-language-server}/lib/language-tools/node_modules/.pnpm/node_modules/@vue/language-server";
    };
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}

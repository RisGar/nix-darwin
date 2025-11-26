{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    signing = {
      key = "7EC2233FD90AF4F1";
      signByDefault = true;
      format = "openpgp";
    };

    lfs.enable = true;

    settings = {
      user = {
        name = "Rishab Garg";
        email = "me@rishab-garg.me";
      };

      core = {
        editor = "nvim";
        pager = "${lib.getExe config.programs.delta.package} --pager='ov -F'";
      };

      interactive = {
        diffFilter = "${lib.getExe config.programs.delta.package} --color-only";
      };

      pager = {
        show = "${lib.getExe config.programs.delta.package} --pager='ov -F --header 3'";
        diff = "${lib.getExe config.programs.delta.package} --features ov-diff";
        log = "${lib.getExe config.programs.delta.package} --features ov-log";
      };

      delta = {
        navigate = true;
        dark = true;
        side-by-side = true;
        "ov-diff" = {
          pager = "ov -F --section-delimiter '^(commit|added:|removed:|renamed:|Δ)' --section-header --pattern '•'";
        };
        "ov-log" = {
          pager = "ov -F --section-delimiter '^commit' --section-header-num 3";
        };
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };

      pull = {
        rebase = false;
      };

      init = {
        defaultBranch = "master";
      };

      credential = {
        helper = lib.getExe pkgs.git-credential-manager;
        # "https://artemis.cit.tum.de" = {
        #   provider = "generic";
        # };
        "https://artemis.tum.de" = {
          provider = "generic";
        };
        "https://git.fs.tum.de" = {
          provider = "generic";
        };
      };
    };
  };

  programs.delta = {
    enable = true;
  };

  xdg.configFile."lazygit/config.yml".source = ./lazygit.yml;
  programs.lazygit = {
    enable = true;
    # don't use settings as nix cannot natively read yaml files
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-markdown-preview ];
    settings = {
      aliases = {
        ".gitignore" = "!gh api -X GET /gitignore/templates/\"$1\" --jq \".source\"";
      };
    };
  };
}

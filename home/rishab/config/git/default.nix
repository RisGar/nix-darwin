{
  config,
  lib,
  pkgs,
  ...
}:
let
  fromYAML =
    p:
    builtins.fromJSON
    <| builtins.readFile
    <| pkgs.runCommand "from-yaml" {
      nativeBuildInputs = [ pkgs.remarshal ];
    } "remarshal -if yaml -i \"${p}\" -of json -o \"$out\"";
in
{
  programs.git = {
    enable = true;

    signing = {
      key = "9ADCCDF12AEBD8B8";
      signByDefault = true;
      format = "openpgp";
      signer = lib.getExe config.programs.gpg.package;
    };

    lfs.enable = true;

    settings = {
      user = {
        name = "Rishab Garg";
        email = "mail@rishab-garg.de";
      };

      gpg.program = lib.getExe config.programs.gpg.package;

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
        rebase = true;
      };

      init = {
        defaultBranch = "main";
      };

      credential = {
        helper = lib.getExe pkgs.git-credential-manager;
        "https://artemis.tum.de" = {
          provider = "generic";
        };
        "https://git.fs.tum.de" = {
          provider = "generic";
        };
        "https://gitlab.lrz.de" = {
          provider = "generic";
        };
      };
    };
  };

  programs.delta = {
    enable = true;
  };

  # xdg.configFile."lazygit/config.yml".source = ./lazygit.yml;
  programs.lazygit = {
    enable = true;
    settings = fromYAML ./lazygit.yml;
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

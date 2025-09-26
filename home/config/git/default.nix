{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    userName = "Rishab Garg";
    userEmail = "me@rishab-garg.me";

    signing = {
      key = "7EC2233FD90AF4F1";
      signByDefault = true;
      format = "openpgp";
    };

    lfs.enable = true;

    extraConfig = {
      core = {
        editor = "nvim";
        pager = "${pkgs.delta}/bin/delta --pager='ov -F'";
      };

      interactive = {
        diffFilter = "${pkgs.delta}/bin/delta --color-only";
      };

      pager = {
        show = "${pkgs.delta}/bin/delta --pager='ov -F --header 3'";
        diff = "${pkgs.delta}/bin/delta --features ov-diff";
        log = "${pkgs.delta}/bin/delta --features ov-log";
      };

      delta = {
        navigate = true;
        dark = true;
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
        helper = "/usr/local/share/gcm-core/git-credential-manager";
        "https://artemis.cit.tum.de" = {
          provider = "generic";
        };
        "https://artemis.tum.de" = {
          provider = "generic";
        };
        "https://git.fs.tum.de" = {
          provider = "generic";
        };
      };
    };
  };
}

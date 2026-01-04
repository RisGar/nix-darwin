{ config, ... }:
{
  programs.eza = {
    enable = true;
    colors = "always";
    icons = "always";
    git = true;
    theme = {
      # Based on One Dark theme from [eza-community/eza-themes: Themes for eza](https://github.com/eza-community/eza-themes)
      colourful = true;

      filekinds = {
        normal = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        directory = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
        symlink = {
          foreground = "#${config.colorScheme.palette.base0C}";
        };
        pipe = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        block_device = {
          foreground = "#${config.colorScheme.palette.base0A}";
        };
        char_device = {
          foreground = "#${config.colorScheme.palette.base0A}";
        };
        socket = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        special = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        executable = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        mount_point = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
      };

      perms = {
        user_read = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        user_write = {
          foreground = "#${config.colorScheme.palette.base09}";
        };
        user_execute_file = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        user_execute_other = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        group_read = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        group_write = {
          foreground = "#${config.colorScheme.palette.base09}";
        };
        group_execute = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        other_read = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        other_write = {
          foreground = "#${config.colorScheme.palette.base09}";
        };
        other_execute = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        special_user_file = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        special_other = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        attribute = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
      };

      size = {
        major = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        minor = {
          foreground = "#${config.colorScheme.palette.base0C}";
        };
        number_byte = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        number_kilo = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        number_mega = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
        number_giga = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        number_huge = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        unit_byte = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        unit_kilo = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
        unit_mega = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        unit_giga = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        unit_huge = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
      };

      users = {
        user_you = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        user_root = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
        user_other = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        group_yours = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        group_other = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        group_root = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
      };

      links = {
        normal = {
          foreground = "#${config.colorScheme.palette.base0C}";
        };
        multi_link_file = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
      };

      git = {
        new = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        modified = {
          foreground = "#${config.colorScheme.palette.base0A}";
        };
        deleted = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
        renamed = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        typechange = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        ignored = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        conflicted = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
      };

      git_repo = {
        branch_main = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        branch_other = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        git_clean = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        git_dirty = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
      };

      security_context = {
        colon = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        user = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        role = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        typ = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        range = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
      };

      file_type = {
        image = {
          foreground = "#${config.colorScheme.palette.base0A}";
        };
        video = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
        music = {
          foreground = "#${config.colorScheme.palette.base0B}";
        };
        lossless = {
          foreground = "#${config.colorScheme.palette.base0C}";
        };
        crypto = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        document = {
          foreground = "#${config.colorScheme.palette.base05}";
        };
        compressed = {
          foreground = "#${config.colorScheme.palette.base0E}";
        };
        temp = {
          foreground = "#${config.colorScheme.palette.base08}";
        };
        compiled = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
        build = {
          foreground = "#${config.colorScheme.palette.base03}";
        };
        source = {
          foreground = "#${config.colorScheme.palette.base0D}";
        };
      };

      punctuation = {
        foreground = "#${config.colorScheme.palette.base03}";
      };
      date = {
        foreground = "#${config.colorScheme.palette.base0A}";
      };
      inode = {
        foreground = "#${config.colorScheme.palette.base03}";
      };
      blocks = {
        foreground = "#${config.colorScheme.palette.base03}";
      };
      header = {
        foreground = "#${config.colorScheme.palette.base05}";
      };
      octal = {
        foreground = "#${config.colorScheme.palette.base0C}";
      };
      flags = {
        foreground = "#${config.colorScheme.palette.base0E}";
      };

      symlink_path = {
        foreground = "#${config.colorScheme.palette.base0C}";
      };
      control_char = {
        foreground = "#${config.colorScheme.palette.base0D}";
      };
      broken_symlink = {
        foreground = "#${config.colorScheme.palette.base08}";
      };
      broken_path_overlay = {
        foreground = "#${config.colorScheme.palette.base03}";
      };
    };
    extraOptions = [
      "--classify=always"
      "--group-directories-first"
    ];
  };
}

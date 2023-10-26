{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.awesome;
in {
  options.home.awesome.enable = lib.mkEnableOption "awesome";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mpc-cli
      rofi
      flameshot
    ];

    xsession = {
      enable = true;
      windowManager.awesome.enable = true;
    };

    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true; # may help with performance
      extraArgs = [
        "--blur-method=dual_kawase"
        "--blur-strength=3"
      ];
    };

    services.mpd = {
      enable = true;
      musicDirectory = "/data/music";
      extraConfig = ''
        audio_output {
          type		"pulse"
          name		"MPD Pulse Output"
        }

        audio_output {
            type                    "fifo"
            name                    "viz"
            path                    "/tmp/mpd.fifo"
            format                  "44100:16:2"
            buffer_time             "5000" # microseconds
        }
      '';
    };

    programs.ncmpcpp = {
      enable = true;
      bindings = [
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "J";
          command = "page_down";
        }
        {
          key = "K";
          command = "page_up";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "l";
          command = "next_column";
        }
      ];
      settings = {
        mpd_host = "127.0.0.1";
        mpd_port = "6600";

        song_columns_list_format = "(7f)[green]{l} (25)[cyan]{a} (3f)[white]{n} (40)[]{t|f} (30)[red]{b}";

        display_bitrate = "yes";
        user_interface = "alternative";
        startup_screen = "media_library";
        main_window_color = "white";

        media_library_primary_tag = "album_artist";
        media_library_albums_split_by_date = "no";

        current_item_inactive_column_prefix = "$(250)$r";
        current_item_inactive_column_suffix = "$/r$(end)";
        current_item_prefix = "$(2)$r";
        current_item_suffix = "$/r$(end)";

        visualizer_fifo_path = "/tmp/mpd.fifo";
        visualizer_output_name = "my_fifo";
        visualizer_sync_interval = 30;
        visualizer_look = "██";
        visualizer_color = "136,135,134,133,132,131";
        visualizer_type = "\"spectrum\"";
        visualizer_spectrum_smooth_look = "yes";
        visualizer_in_stereo = "yes";
        visualizer_spectrum_hz_max = 16000;
        visualizer_spectrum_gain = 26;

        progressbar_look = "██-";
        progressbar_color = "white";
        progressbar_elapsed_color = "green";
      };
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.8;
        font = {
          size = 12;
        };
      };
    };

    # this is broken. xscreensaver never reads the settings nor can they be set with ~/.xscreensaver
    # services.xscreensaver = {
    #   enable = true;
    #   settings = {
    #     mode = "blank";
    #     selected = 1;
    #     programs = "hexadrop -root -delay 2655 -speed 0.55 -sides 6 -no-lockstep";
    #   };
    # };

    home.file.".config/awesome/rc.lua".source = ./rc.lua;
  };
}

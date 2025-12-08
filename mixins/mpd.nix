{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.home.music.mpd;
in {
  options.home.music.mpd = {
    enable = lib.mkEnableOption "MPD music player";

    musicDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/data/music";
      description = "Path to music directory";
    };

    audioOutput = lib.mkOption {
      type = lib.types.str;
      default = "pipewire";
      description = "Audio output type (e.g., pipewire, pulse, alsa)";
    };

    wslBullshit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable WSL2-specific workarounds (software mixer + explicit server)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mpc
    ];

    services.mpd = {
      enable = true;
      musicDirectory = cfg.musicDirectory;
      extraConfig = ''
        audio_output {
          type		"${cfg.audioOutput}"
          name		"${cfg.audioOutput}"

        ${lib.optionalString cfg.wslBullshit ''
          server      "unix:/mnt/wslg/PulseServer"
          mixer_type  "software"
        ''}
        }
        audio_output {
          type        "fifo"
          name        "viz"
          path        "${config.services.mpd.dataDir}/fifo"
          format      "44100:16:2"
          buffer_time "5000"
        }
      '';
    };

    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {
        visualizerSupport = true;
        taglibSupport = false;
        clockSupport = false;
      };
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
        mpd_host = config.services.mpd.network.listenAddress;
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
        visualizer_data_source = "${config.services.mpd.dataDir}/fifo";
        visualizer_output_name = "my_fifo";
        visualizer_look = "██";
        visualizer_color = "136,135,134,133,132,131";
        visualizer_type = ''"spectrum"'';
        visualizer_spectrum_smooth_look = "yes";
        visualizer_in_stereo = "yes";
        visualizer_spectrum_hz_max = 16000;
        visualizer_spectrum_gain = 26;
        progressbar_look = "██-";
        progressbar_color = "white";
        progressbar_elapsed_color = "green";
      };
    };
  };
}

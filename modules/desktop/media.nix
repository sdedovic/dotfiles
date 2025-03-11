{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg_7-headless
    yt-dlp
    imagemagick

    # usb etcher / imager
    caligula
  ];
}

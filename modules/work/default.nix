{pkgs, ...}: {
  imports = [
    ../desktop
  ];

  home.packages = with pkgs; [kaf go-migrate terraform supabase-cli yamlfmt tailscale circleci-cli awscli2 aws-sam-cli steampipe];
}

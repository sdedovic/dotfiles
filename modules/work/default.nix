{pkgs, ...}: {
  imports = [
    ../desktop
  ];

  home.packages = with pkgs; [
    # redis
    valkey

    # kafka
    kaf
    kcat

    # postgres
    (go-migrate.overrideAttrs (oldAttrs: {
      # only need pg support smaller bin this way
      tags = ["postgres"];
    }))

    temporal
    opentelemetry-collector
    codex

    # infra
    doctl
    terraform
    supabase-cli
    tailscale
    circleci-cli
    awscli2
    # aws-sam-cli
    steampipe
    scorecard

    # misc
    yamlfmt
    graphviz
    ttyplot
    uutils-coreutils
    python-kacl
  ];
}

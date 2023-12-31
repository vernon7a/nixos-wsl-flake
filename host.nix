{ pkgs, inputs, ... }: {
  time.timeZone = "Asia/Shanghai";
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  environment.systemPackages = with pkgs; [
    git
    gcc
    zig
    unzip
    gnumake
    clang-tools
    cmake
    cargo
  ];

  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
    "home-manager=${inputs.home-manager}"
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.registry = {
    # Makes `nix run nixpkgs#...` run using the nixpkgs from this flake
    nixpkgs.flake = inputs.nixpkgs;

    # inputs.self is a reference to this flake, which allows self-references.
    # In this case, adding this flake to the registry under the name `my`,
    # which is the name I use any time I'm customising stuff.
    # (at time of writing, this is only used for `nix flake init -t my#...`)
    my.flake = inputs.self;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.pcscd.enable = true;

  # This needs to be set to get the default system-level fish configuration, such
  # as completions for Nix and related tools. This is also required because on macOS
  # the $PATH doesn't include all the entries it should by default.
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
  services.tailscale.enable = true;
}

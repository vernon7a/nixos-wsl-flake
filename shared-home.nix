{pkgs, ...}: {
  home.stateVersion = "23.11";
  home.username = "vernon7a";

  home.packages = with pkgs; [
    neovim

    fd
    ripgrep
    fzf

    eza
    jq
    glow

    curl
    croc
    wget
  ];

  programs = {
    # broot.enable = true;
    # zoxide.enable = true;
    home-manager.enable = true;
    zellij.enable = true;
    # nushell.enable = true;
    # gh.enable = true;
    bat = {
      enable = true;
      config.theme = "gruvbox-dark";
    };
  };
}

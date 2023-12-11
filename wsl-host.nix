{pkgs, ...}: {
  imports = [
    ./shared-host.nix
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.enabled = false;
    wslConf.interop.appendWindowsPath = false;
    defaultUser = "vernon7a";
    startMenuLaunchers = false;
    nativeSystemd = true;
  };

  users.users.vernon7a = {
    description = "vernon7a";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];
    hashedPassword = "$y$j9T$fdmQNBEaAn1tzSsNyhL7a/$l6u1ZKbc9iFjAWdejmnFjyivW7CxSoeDWFrVZGHdNPB";
  };

  # Using a purely declarative user setup. This means any future users will have to
  # have a password hash generated with `mkpasswd`
  users.mutableUsers = false;

  # Needs to be set explicitly because nixos-wsl disables this for ease of installation
  security.sudo.wheelNeedsPassword = true;
  users.users.root.hashedPassword = "$y$j9T$lf/H57PbhhgaCcdfmZZVq/$h339ZOR/E.lzgv57rrBYLjCYJm64/1mKZZjvqObyRgA";

  networking.hostName = "nixos-wsl";

  system.stateVersion = "23.11";
}

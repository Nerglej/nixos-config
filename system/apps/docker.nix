{ lib, userSettings, ... }: 

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  users.users.${userSettings.username}.extraGroups = [ "docker" ];
}

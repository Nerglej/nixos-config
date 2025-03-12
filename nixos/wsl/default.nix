{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  systemSettings = {
    system = "x86_64-linux";
    hostname = "wsl";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
  };
in {
}

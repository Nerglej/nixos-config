{ pkgs, ... }: 

{
  environment.systemPackages = [
    pkgs.rquickshare
  ];
}

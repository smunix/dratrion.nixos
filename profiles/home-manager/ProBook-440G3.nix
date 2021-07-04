{ config, pkgs, ... }:
let
  qtPkgs = with pkgs; [ kdenlive ];
  ricePkgs = with pkgs; [ orchis-theme flat-remix-gnome whitesur-icon-theme ];

in { home.packages = builtins.concatLists [ qtPkgs ricePkgs ]; }
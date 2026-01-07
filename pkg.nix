{ pkgs, appimageTools, fetchurl, stdenv, fetchFromGitHub }:

let
  cleanName = "Fladder";

  version = "0.9.0";

  src = fetchurl {
    url =
      "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-Linux-${version}.AppImage";
    hash = "sha256-L9dyqEGrMlGW6C7Jj4nhM5X/DlJ3vDNL4pSlsVel8Iw=";
  };

  ghSource = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    hash = "sha256-IX3qbIgfi9d8rP24yIGlBzi5l28YQWnvLD+dD+7uIZc=";
  };

  pname = "fladder";

  build = appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = (_: with pkgs; [ mpv libepoxy ]);
  };

  desktopEntry = pkgs.makeDesktopItem {
    name = pname;
    desktopName = cleanName;
    comment = "A client for Jellyfin";
    exec = "${build}/bin/${pname} %f";
    icon = "${ghSource}/icons/production/fladder_icon_desktop.png";
  };

in stdenv.mkDerivation {
  name = pname;

  src = build;

  installPhase = ''
    mkdir -p $out/bin
    cp bin/${pname} $out/bin/${pname}

    mkdir -p $out/share/applications
    cp ${desktopEntry}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
  '';
}

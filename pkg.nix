{
  pkgs,
  appimageTools,
  fetchurl,
  stdenv,
  fetchFromGitHub,
  lib,
}: let
  cleanName = "Fladder";

  version = "0.10.3";

  src = fetchurl {
    url = "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-Linux-${version}.AppImage";
    # hash = lib.fakeHash;
    hash = "sha256-t9/rB7Iv0GI5HJWwBUQwfxISPpbYPeRouS6oD8BKMEY=";
  };

  ghSource = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    # hash = lib.fakeHash;
    hash = "sha256-0eFHylRi2UVaKRG7K3tDZVscgoiL5xFrtFhZiJxj4Mk=";
  };

  pname = "fladder";

  build = appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = _: with pkgs; [mpv libepoxy lz4];
  };

  desktopEntry = pkgs.makeDesktopItem {
    name = pname;
    desktopName = cleanName;
    comment = "A client for Jellyfin";
    exec = "${build}/bin/${pname} %f";
    icon = "${ghSource}/icons/production/fladder_icon_desktop.png";
  };
in
  stdenv.mkDerivation {
    name = pname;

    src = build;

    installPhase = ''
      mkdir -p $out/bin
      cp bin/${pname} $out/bin/${pname}

      mkdir -p $out/share/applications
      cp ${desktopEntry}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
    '';
  }

{
  pkgs,
  appimageTools,
  fetchurl,
  stdenv,
  fetchFromGitHub,
}: let
  cleanName = "Fladder";

  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-Linux-${version}.AppImage";
    hash = "sha256-LU2IFM7Jt/Cbr3BNMgUrNFER0RD/oTlBoG1a+znsC1M=";
  };

  ghSource = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    hash = "sha256-wY2h6lJWFH7UNxzGrSOLDj4cjAY9VAG8IUYaxWugVQQ=";
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

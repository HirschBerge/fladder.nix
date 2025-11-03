This flake packages [Fladder](https://github.com/DonutWare/Fladder/).

Unfortunately, using `flutter.buildFlutterApplication` fails, because Fladder uses MediaKit, which doesn't build in the Nix build env.
That's why the appimage was used.

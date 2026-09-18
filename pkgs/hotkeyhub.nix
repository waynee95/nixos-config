{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  glib,
  gobject-introspection,
  gdk-pixbuf,
  libadwaita,
  gtk4,
}:

stdenv.mkDerivation {
  pname = "hotkeyhub";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/meowrch/HotKeyHub/releases/download/v1.0.0/hotkeyhub-linux-x86_64";
    hash = "sha256-eA+xrYySJItqEYQPz03QOgfJwN2TCcK8KegLojRIXe8=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    glib
    gobject-introspection
    gdk-pixbuf
    libadwaita
    gtk4
  ];

  sourceRoot = ".";

  unpackPhase = ''
    cp "$src" hotkeyhub
    chmod +x hotkeyhub
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 hotkeyhub "$out/bin/hotkeyhub"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Cheat sheet overlay for Hyprland keybindings";
    homepage = "https://github.com/meowrch/HotKeyHub";
    license = licenses.mit;
    mainProgram = "hotkeyhub";
    platforms = platforms.linux;
  };
}

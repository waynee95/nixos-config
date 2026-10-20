{
  subversion,
  pkg-config,
  libsecret,
  symlinkJoin,
  makeWrapper,
}:

let
  subversionWithKeyring = subversion.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkg-config ];
    buildInputs = (old.buildInputs or [ ]) ++ [ libsecret ];
    configureFlags = (old.configureFlags or [ ]) ++ [ "--with-gnome-keyring" ];
  });
in
symlinkJoin {
  name = "subversion-with-keyring-${subversionWithKeyring.version}";
  paths = [ subversionWithKeyring ];
  nativeBuildInputs = [ makeWrapper ];

  # APR loads authentication plugins with dlopen, which does not use svn's RUNPATH.
  postBuild = ''
    for client in svn svnmucc; do
      wrapProgram "$out/bin/$client" \
        --prefix LD_LIBRARY_PATH : "${subversionWithKeyring}/lib"
    done
  '';
}

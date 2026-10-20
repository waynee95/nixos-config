{ ... }:

{
  home.file.".subversion/config".text = ''
    [auth]
    password-stores = gnome-keyring
  '';

  home.file.".subversion/servers".text = ''
    [global]
    store-passwords = yes
    store-auth-creds = yes
    store-plaintext-passwords = no
  '';
}

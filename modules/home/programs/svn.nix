{ ... }:

{
  home.file.".subversion/config".text = ''
    [auth]
    password-stores = gnome-keyring
  '';

  # Client settings for remote servers, including credential caching.
  home.file.".subversion/servers".text = ''
    [global]
    store-passwords = yes
    store-auth-creds = yes
    store-plaintext-passwords = no
  '';
}

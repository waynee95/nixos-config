{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lf
  ];

  home.file.".config/lf/lfrc".text = ''
    set icons
    set preview
    set relativenumber

    map <c-.> set hidden!
    map <esc> quit
    map e $$EDITOR "$f"
    map x trash
  '';

  home.file.".config/lf/icons".text = ''
    di  󰉋
    fi  󰈙
    ln  󰌕
    ex  󰌑
    pi  󰌊
    so  󰌋
    bd  󰉁
    cd  󰉈
    tw  󰉊
    ow  󰉉
    st  󰉉
    su  󰉉

    # common file types
    nix      󱄅
    lua      󰢱
    markdown 󰍔
    md       󰍔
    sh       󰞷
    bash     󰞷
    zsh      󰞷
    fish     󰞷
    py       󰌠
    c        󰙱
    cpp      󰙲
    h        󰙱
    rs       󰞨
    hs       󰞶
    go       󰟓
    tex      󰙩
    pdf      󰈫
    json     󰘬
    yaml     󰘬
    toml     󰘬
    txt      󰉿
    git*     󰊢
  '';
}

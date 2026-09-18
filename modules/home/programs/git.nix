{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    ignores = [
      ".direnv"
      ".envrc"
      "*.swp"
    ];

    settings = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };
      pull = {
        ff = "only";
      };
      push = {
        default = "simple";
      };
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
      status = {
        showUntrackedFiles = "all";
      };
      diff = {
        tool = "nvimdiff";
      };
      difftool = {
        prompt = false;
        "nvimdiff".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      };
      merge = {
        tool = "nvimdiff";
        conflictstyle = "diff3";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
        "nvimdiff".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
      };
      color = {
        ui = "auto";
      };
      color.branch = {
        current = "yellow reverse";
        remote = "green";
      };
      color.diff = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      color.status = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };
      alias = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        st = "status";
        g = "grep --break --heading --line-number";
        d = "difftool";
        dt = "difftool";
        mt = "mergetool";
      };
    };
  };
}

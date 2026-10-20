{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    initContent = ''
      # auto start tmux if not already in a tmux session
      if { [[ -z ''$TMUX ]] } && { [[ -z ''$SSH_CLIENT ]] }; then
        exec tmux new-session -A -s main
      fi

      source ~/.zsh/prompt.zsh
      bindkey -e

      # ctrl key bindings
      bindkey '^A' beginning-of-line 
      bindkey '^K' kill-line         
      bindkey -r '^T'                

      # home and end key bindings
      bindkey '^[[1~' beginning-of-line
      bindkey '^[[4~' end-of-line 

      # history search up and down arrow
      bindkey '^[[A' history-beginning-search-backward
      bindkey '^[[B' history-beginning-search-forward
    '';
  };

  programs.zsh.plugins = [
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.ripgrep}/bin/rg --files --hidden --follow -g '!.git/*'";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
    fileWidget.options = [
      "--preview '${pkgs.ripgrep}/bin/rg --hidden --pretty --context 0 {2..}'"
    ];
  };

  # automatically enter default.nix shell when entering a directory containing
  # requires a .envrc file containing `use nix`, then run `direnv allow` to allow it
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".zsh/prompt.zsh".text = ''
        autoload -Uz vcs_info
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:git:*' formats ' %F{green}%b%f'
        zstyle ':vcs_info:*' actionformats ' %F{red}%b%f'
        setopt PROMPT_SUBST
        precmd() { vcs_info }
        PROMPT="
    %F{blue}%~''$vcs_info_msg_0_
    %F{green}λ%f "
  '';

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.cabal/bin"
    "$HOME/.ghcup/bin"
    "$HOME/.cargo/bin"
    "$HOME/.elan/bin"
  ];

  home.shellAliases = {
    docs = "cd $HOME/Documents";
  };
}

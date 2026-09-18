{ ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    escapeTime = 0;
    baseIndex = 1;

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      # pass through xterm keys to the termal, otherwise ctrl+a / ctrl+k will not work 
      set -g xterm-keys on
      setw -g xterm-keys on
      setw -g mode-keys vi
      setw -g monitor-activity on

      # split panes
      bind S split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'
      unbind '"'
      unbind %

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf

      # vim-like pane navigation
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
    '';
  };
}

if status is-interactive
    # Commands to run in interactive sessions can go here
    alias emacs 'emacsclient -t'
    alias em 'emacsclient -t'
    set XDG_CONFIG_HOME "~/.config/"
    if not set -q TMUX
       exec tmux
    end
end

# Created by `pipx` on 2024-09-10 21:17:22
set PATH $PATH /home/jj/.local/bin

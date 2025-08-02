if status is-interactive
    # Commands to run in interactive sessions can go here	
      	# Set up the em command to run emacs (in terminal)
      	alias em 'emacs -nw'
	# Launch term customiser for graphics
	oh-my-posh init fish --config ~/.config/oh-my-posh/darkblood.omp.json | source
	# Launch tmux if tmux is not already running
	if not set -q TMUX
	    exec tmux
	end
end


# Created by `pipx` on 2024-09-06 22:40:37
set PATH $PATH /Users/jj/.local/bin

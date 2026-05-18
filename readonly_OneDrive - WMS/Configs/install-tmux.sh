#If installing tmux
sudo apt -y update
sudo apt install -y tmux bat 
apt install -y python3-venv

mkdir -p ~/.config/tmux
touch ~/.config/tmux/tmux.conf

# clone tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# config
batcat << 'EOF' >> ~/.config/tmux/tmux.conf

set -g allow-passthrough on
set -ga update-environment TERM
set -g visual-activity off

# List of plugins
set -g @plugin 'tmux-plugins/tpm'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF

# type this in terminal if tmux is already running
tmux kill-server
tmux source ~/.tmux.conf
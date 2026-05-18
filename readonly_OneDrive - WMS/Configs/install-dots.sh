# Install

sudo apt update && sudo apt -y install stow
git clone https://github.com/bryannaranjo/dots.git
cd dots
stow tmux zsh yazi
cd ~

# Install zsh
sudo apt install -y zsh 
sudo apt install -y zoxide eza bat fzf ripgrep thefuck 
#tldr

#install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#make default
# chsh -s $(which zsh)

#######################################
# RUN BELOW SEPARATE

# Install Plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# 1. Download Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 2. Download Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install tmux
sudo apt -y install tmux bat

# clone tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# Debian install yazi
sudo apt install -y ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick xclip wl-clipboard xsel
#sudo snap install yazi --classic

#!/bin/bash
sudo apt install -y wget unzip
# 1. Download the specific file
wget https://github.com/sxyazi/yazi/releases/download/v25.5.31/yazi-x86_64-unknown-linux-gnu.zip

# 2. Extract it
unzip yazi-x86_64-unknown-linux-gnu.zip

# 3. Move the binaries to /usr/bin (requires password)
sudo mv yazi-x86_64-unknown-linux-gnu/yazi /usr/bin/
sudo mv yazi-x86_64-unknown-linux-gnu/ya /usr/bin/

# 4. Clean up
rm -rf yazi-x86_64-unknown-linux-gnu*


#NerdFonts
sudo apt -y install fonts-firacode
fc-list | grep "Nerd"

#install ya packages
ya pkg add 956MB/vscode-dark-modern
ya pkg add yazi-rs/flavors:catppuccin-frappe
ya pkg add AdithyanA2005/nord
ya pkg add dangooddd/kanagawa
ya pkg add kalidyasin/yazi-flavors:tokyonight-night
ya pkg add BennyOe/tokyo-night
ya pkg add 956MB/vscode-dark-modern
ya pkg add tkapias/nightfly
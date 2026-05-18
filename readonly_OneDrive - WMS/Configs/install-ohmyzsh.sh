sudo apt update
sudo apt install zsh -y
sudo apt install -y zoxide eza bat fzf ripgrep thefuck 
#tldr

#install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#make default
chsh -s $(which zsh)

#######################################
# RUN BELOW SEPARATE

# Install Plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# 1. Download Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 2. Download Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 3. zsh-completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# config
batcat << 'EOF' >> ~/.zshrc

source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
alias cat='bat'
alias cd='z' 
alias ls='eza --color=always --long'
alias tree="eza --tree -L2"
EOF

#plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
#theme
sed -i 's/^[[:space:]]*ZSH_THEME=.*/ZSH_THEME="steeef"/' ~/.zshrc

# ZSH_THEME_RANDOM_CANDIDATES=( "jonathan" "steeef" "linuxonly" "essembeh" "tjkirch" "duellj" "kiwi" "mikeh" "fino" "fox" "funky" "muse" "gnzh" )

sed -i 's/^[[:space:]]*ZSH_THEME_RANDOM_CANDIDATES=.*/ZSH_THEME_RANDOM_CANDIDATES=( "jonathan" "steeef" "agnoster" "essembeh" "tjkirch" "duellj" "kiwi" "mikeh" "fino" "fox" "funky" "muse" "gnzh")/' ~/.zshrc
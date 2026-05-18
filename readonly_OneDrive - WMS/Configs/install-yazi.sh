sudo apt update
sudo apt install zsh -y

#make default
chsh -s $(which zsh)

#install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Debian install yazi
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick xclip wl-clipboard xsel
#sudo snap install yazi --classic

#!/bin/bash
sudo apt install wget unzip -y
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
sudo apt install fonts-firacode
fc-list | grep "Nerd"

# make sure chmod 755 on dirs 644 on files
mkdir -p ~/.config/yazi/flavors
touch ~/.config/yazi/yazi.toml
touch ~/.config/yazi/keymap.toml
touch ~/.config/yazi/theme.toml

# #If installing tmux or byobu
# sudo apt install tmux -y
# mkdir -p ~/.config/tmux
# touch ~/.config/tmux/tmux.conf
# cat << 'EOF' >> ~/.config/tmux/tmux.conf
# set -g allow-passthrough on
# set -ga update-environment TERM
# set -g visual-activity off
# EOF
# tmux kill-server

#config zshrc-bash/zsh profile
cat << 'EOF' >> ~/.zshrc

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

alias ya='/usr/bin/ya'
export EDITOR="nano"
eval "$(zoxide init zsh)"
EOF

source ~/.zshrc

#install ya packages
ya pkg add 956MB/vscode-dark-modern
ya pkg add yazi-rs/flavors:catppuccin-frappe
ya pkg add AdithyanA2005/nord
ya pkg add dangooddd/kanagawa
ya pkg add kalidyasin/yazi-flavors:tokyonight-night
ya pkg add BennyOe/tokyo-night
ya pkg add 956MB/vscode-dark-modern
ya pkg add tkapias/fightfly

#config theme
cat << 'EOF' > ~/.config/yazi/theme.toml
[flavor]
dark = "catppuccin-frappe"
EOF

#config yazi
cat << 'EOF' > ~/.config/yazi/yazi.toml
# A TOML linter such as https://taplo.tamasfe.dev/ can use this schema to validate your config.
# If you encounter any issues, please make an issue at https://github.com/yazi-rs/schemas.
"$schema" = "https://yazi-rs.github.io/schemas/yazi.json"

[mgr]
ratio          = [ 1, 4, 3 ]
sort_by        = "alphabetical"
sort_sensitive = false
sort_reverse  = false
sort_dir_first = true
sort_translit  = false
linemode       = "none"
show_hidden    = false
show_symlink   = true
scrolloff      = 5
mouse_events   = [ "click", "scroll" ]
title_format   = "Yazi: {cwd}"

[preview]
image= "yes"
wrap            = "no"
tab_size        = 2
max_width       = 600
max_height      = 900
cache_dir       = ""
image_delay     = 30
image_filter    = "triangle"
image_quality   = 75
ueberzug_scale  = 1
ueberzug_offset = [ 0, 0, 0, 0 ]

[opener]
edit = [
{ run = '${EDITOR:-vi } "$@"', desc = "$EDITOR",      for = "unix", block = true },
{ run = "nano %*",          desc = "nano",         for = "windows", block = true },
{ run = "nano -w %*",       desc = "nano (block)", for = "windows", block = true },
]
play = [
{ run = 'xdg-open "$@"',                desc = "Play", for = "linux" },
{ run = "open %s",                     desc = "Play", for = "macos" },
{ run = 'start "" "%1"', orphan = true, desc = "Play", for = "windows" },
{ run = "termux-open %s1",             desc = "Play", for = "android" },
{ run = "mediainfo %s1; echo 'Press enter to exit'; read _", block = true, desc = "Show media info", for = "unix" },
{ run = "mediainfo %s1 & pause", block = true, desc = "Show media info", for = "windows" },
]
open = [
{ run = 'xdg-open "$@"',    desc = "Open", for = "linux" },
{ run = "open %s",         desc = "Open", for = "macos" },
{ run = 'start "" "%1"',    desc = "Open", for = "windows", orphan = true },
{ run = "termux-open %s1", desc = "Open", for = "android" },
]
reveal = [
{ run = 'xdg-open "$(dirname "$1")"',         desc = "Reveal", for = "linux" },
{ run = "open -R %s1",          desc = "Reveal", for = "macos" },
{ run = 'explorer /select,"%1"', desc = "Reveal", for = "windows", orphan = true },
{ run = "termux-open %d1",      desc = "Reveal", for = "android" },
{ run = "clear; exiftool %s1; echo 'Press enter to exit'; read _", desc = "Show EXIF", for = "unix", block = true },
]
extract = [
{ run = 'ya pub extract --list "$@"', desc = "Extract here", for = "unix"  },
{ run = 'ya pub extract --list %*', desc = "Extract here", for =  "windows" },
]
download = [
{ run = "ya emit download --open %S", desc = "Download and open" },
{ run = "ya emit download %S",        desc = "Download" },
]

[open]
rules = [
# Folder
{ url = "*/", use = [ "edit", "open", "reveal" ] },
# Text
{ mime = "text/*", use = [ "edit", "reveal" ] },
# Image
{ mime = "image/*", use = [ "open", "reveal" ] },
# Media
{ mime = "{audio,video}/*", use = [ "play", "reveal" ] },
# Archive
{ mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", use = [ "extract", "reveal" ] },
# JSON
{ mime = "application/{json,ndjson}", use = [ "edit", "reveal" ] },
{ mime = "*/javascript", use = [ "edit", "reveal" ] },
# Empty file
{ mime = "inode/empty", use = [ "edit", "reveal" ] },
# Virtual file system
{ mime = "vfs/{absent,stale}", use = "download" },
# Fallback
{ url = "*", use = [ "open", "reveal" ] },
]

[tasks]
micro_workers    = 10
macro_workers    = 10
bizarre_retry    = 3
image_alloc      = 536870912  # 512MB
image_bound      = [ 10000, 10000 ]
suppress_preload = false


[input]
cursor_blink = false

# cd
cd_title  = "Change directory:"
cd_origin = "top-center"
cd_offset = [ 0, 2, 50, 3 ]

# create
create_title  = [ "Create:", "Create (dir):" ]
create_origin = "top-center"
create_offset = [ 0, 2, 50, 3 ]

# rename
rename_title  = "Rename:"
rename_origin = "hovered"
rename_offset = [ 0, 1, 50, 3 ]

# filter
filter_title  = "Filter:"
filter_origin = "top-center"
filter_offset = [ 0, 2, 50, 3 ]

# find
find_title  = [ "Find next:", "Find previous:" ]
find_origin = "top-center"
find_offset = [ 0, 2, 50, 3 ]

# search
search_title  = "Search via {n}:"
search_origin = "top-center"
search_offset = [ 0, 2, 50, 3 ]

# shell
shell_title  = [ "Shell:", "Shell (block):" ]
shell_origin = "top-center"
shell_offset = [ 0, 2, 50, 3 ]

[confirm]
# trash
trash_title = "Trash {n} selected file{s}?"
trash_origin= "center"
trash_offset= [ 0, 0, 70, 20 ]

# delete
delete_title = "Permanently delete {n} selected file{s}?"
delete_origin= "center"
delete_offset= [ 0, 0, 70, 20 ]

# overwrite
overwrite_title  = "Overwrite file?"
overwrite_body   = "Will overwrite the following file:"
overwrite_origin = "center"
overwrite_offset = [ 0, 0, 50, 15 ]

# quit
quit_title  = "Quit?"
quit_body   = "The following tasks are still running, are you sure you want to quit?"
quit_origin = "center"
quit_offset = [ 0, 0, 50, 15 ]

[pick]
open_title  = "Open with:"
open_origin = "hovered"
open_offset = [ 0, 1, 50, 7 ]

[which]
sort_by       = "none"
sort_sensitive = false
sort_reverse  = false
sort_translit  = false

EOF

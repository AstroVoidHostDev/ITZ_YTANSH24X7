#!/bin/bash

# ================= COLORS =================
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

# ================= FUNCTIONS =================
animate() {
  text="$1"; color="$2"
  for ((i=0;i<${#text};i++)); do
    echo -ne "${color}${text:$i:1}${RESET}"
    sleep 0.03
  done
  echo
}

pause(){ read -p "Press ENTER to continue..."; }

banner(){
clear
echo -e "${BOLD}${CYAN}"
echo "██╗████████╗███████╗    ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝    ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝      ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝        ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "██║   ██║   ███████╗       ██║      ██║   ██║  ██║██║ ╚████║███████║██║  ██║"
echo "╚═╝   ╚═╝   ╚══════╝       ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "${RESET}${BOLD}        ITZ_YTANSH MC SERVER MAKER${RESET}"
echo
}

select_ram(){
echo -e "${YELLOW}[1] 2GB  [2] 4GB  [3] 6GB  [4] 8GB${RESET}"
read -p "Select RAM -> " r
case $r in
  1) RAM="2G";;
  2) RAM="4G";;
  3) RAM="6G";;
  4) RAM="8G";;
  *) echo -e "${RED}Invalid RAM${RESET}"; return 1;;
esac
}

check_java(){
command -v java >/dev/null || {
  echo "Installing Java..."
  apt update && apt install openjdk-17-jre -y
}
}

create_server(){
animate "Creating..." "$YELLOW"

read -p "Type -> paper : " ok
[[ "$ok" != "paper" ]] && animate "Cancelled" "$RED" && pause && return

read -p "Minecraft Version -> " ver
read -p "Server Name (no space) -> " name
[[ "$name" =~ \  ]] && echo "No spaces allowed" && pause && return

select_ram || { pause; return; }

mkdir -p servers/$name && cd servers/$name || exit

animate "Downloading server.jar..." "$YELLOW"
curl -s -o server.jar \
https://api.papermc.io/v2/projects/paper/versions/$ver/builds/latest/downloads/paper-$ver-latest.jar

[[ ! -s server.jar ]] && animate "Invalid Version!" "$RED" && cd ../../ && pause && return

echo "eula=true" > eula.txt

animate "Starting server (console below)..." "$GREEN"
java -Xms$RAM -Xmx$RAM -jar server.jar nogui
cd ../../
}

delete_server(){
clear
echo -e "${RED}${BOLD}DELETE SERVER${RESET}"
ls servers 2>/dev/null | nl
read -p "Select number -> " n
srv=$(ls servers | sed -n "${n}p")
[[ -z "$srv" ]] && echo "Invalid" && pause && return
animate "Deleting $srv..." "$RED"
rm -rf servers/$srv
animate "Deleted!" "$GREEN"
pause
}

# ================= MAIN =================
mkdir -p servers
check_java

while true; do
banner
echo -e "${YELLOW}[1] Create Minecraft Server"
echo -e "[2] Delete Minecraft Server"
echo -e "[3] Exit${RESET}"
read -p "Choose -> " c
case $c in
  1) create_server;;
  2) delete_server;;
  3) exit;;
  *) pause;;
esac
done

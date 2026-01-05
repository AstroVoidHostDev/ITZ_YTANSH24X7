#!/bin/bash

# ---------- COLORS ----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

animate() {
  text="$1"
  color="$2"
  for ((i=0; i<${#text}; i++)); do
    echo -ne "${color}${text:$i:1}${RESET}"
    sleep 0.04
  done
  echo
}

pause() {
  read -p "Press ENTER to continue..."
}

banner() {
clear
echo -e "${BOLD}${CYAN}"
echo "██╗████████╗███████╗    ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝    ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝      ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝        ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "██║   ██║   ███████╗       ██║      ██║   ██║  ██║██║ ╚████║███████║██║  ██║"
echo "╚═╝   ╚═╝   ╚══════╝       ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "${RESET}"
echo -e "${BOLD}      ITZ_YTANSH MC SERVER MAKER${RESET}"
echo
}

select_ram() {
echo -e "${YELLOW}[1] 2GB RAM"
echo -e "[2] 4GB RAM"
echo -e "[3] 6GB RAM"
echo -e "[4] 8GB RAM${RESET}"
echo
read -p "Select RAM -> " r

case $r in
  1) RAM="2G" ;;
  2) RAM="4G" ;;
  3) RAM="6G" ;;
  4) RAM="8G" ;;
  *) echo -e "${RED}Invalid RAM selection${RESET}"; return 1 ;;
esac
return 0
}

create_server() {
animate "Creating..." "$YELLOW"

read -p "Type -> paper : " check
[[ "$check" != "paper" ]] && animate "Cancelled" "$RED" && pause && return

read -p "Version -> " version
read -p "Server Name (no spaces) -> " name

[[ "$name" =~ \  ]] && echo "No spaces allowed!" && pause && return

select_ram || { pause; return; }

mkdir -p servers/$name
cd servers/$name || exit

animate "Downloading server.jar..." "$YELLOW"
curl -s -o server.jar https://api.papermc.io/v2/projects/paper/versions/$version/builds/latest/downloads/paper-$version-latest.jar

if [[ ! -f server.jar || ! -s server.jar ]]; then
  animate "Invalid version!" "$RED"
  cd ../../
  pause
  return
fi

echo "eula=false" > eula.txt
read -p "EULA -> true/false : " eula

[[ "$eula" != "true" ]] && animate "Cancelled" "$RED" && cd ../../ && pause && return

sed -i 's/false/true/' eula.txt

read -p "Create server? -> yes/no : " final
[[ "$final" != "yes" ]] && animate "Cancelled" "$RED" && cd ../../ && pause && return

animate "Starting server with $RAM RAM..." "$GREEN"
java -Xms$RAM -Xmx$RAM -jar server.jar nogui
}

delete_server() {
clear
echo -e "${BOLD}${RED}DELETE MINECRAFT SERVER${RESET}"
echo

ls servers 2>/dev/null | nl
read -p "Choose number -> " n

target=$(ls servers | sed -n "${n}p")
[[ -z "$target" ]] && echo "Invalid choice" && pause && return

animate "Deleting server... Say goodbye 💔" "$RED"
rm -rf servers/$target
animate "Deleted successfully" "$GREEN"
pause
}

mkdir -p servers

while true
do
banner
echo -e "${YELLOW}[1] Create Minecraft Server"
echo -e "[2] Delete Minecraft Server${RESET}"
echo
read -p "Choose -> " c

case $c in
  1) create_server ;;
  2) delete_server ;;
  *) echo "Invalid option"; pause ;;
esac
done

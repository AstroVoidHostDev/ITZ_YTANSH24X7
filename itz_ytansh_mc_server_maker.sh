#!/bin/bash

# ---------------- COLORS ----------------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# ---------------- FUNCTIONS ----------------
animate_text() {
  text="$1"
  color="$2"
  for ((i=0; i<${#text}; i++)); do
    echo -ne "${color}${text:$i:1}${RESET}"
    sleep 0.05
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
echo -e "${BOLD}        ITZ_YTANSH MC SERVER MAKER${RESET}"
echo
}

create_server() {
  animate_text "Creating..." "$YELLOW"

  read -p "Type -> paper : " confirm
  [[ "$confirm" != "paper" ]] && echo "Cancelled" && pause && return

  read -p "Version -> " version
  read -p "Server Name (no spaces) -> " sname

  if [[ "$sname" =~ \  ]]; then
    echo "❌ No spaces allowed!"
    pause
    return
  fi

  mkdir -p servers/$sname
  cd servers/$sname || exit

  animate_text "Downloading server.jar..." "$YELLOW"

  curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/$version/builds/latest/downloads/paper-$version-latest.jar

  if [[ ! -f server.jar ]]; then
    echo "❌ Invalid version!"
    cd ../../
    pause
    return
  fi

  echo "eula=false" > eula.txt
  read -p "EULA -> true/false : " eula

  if [[ "$eula" != "true" ]]; then
    animate_text "Process cancelled." "$RED"
    cd ../../
    pause
    return
  fi

  sed -i 's/false/true/g' eula.txt

  read -p "Create server? -> yes/no : " final
  if [[ "$final" != "yes" ]]; then
    animate_text "Cancelled." "$RED"
    cd ../../
    pause
    return
  fi

  animate_text "Server starting..." "$GREEN"
  java -Xmx2G -Xms2G -jar server.jar nogui
}

delete_server() {
  clear
  echo -e "${BOLD}${RED}DELETE MINECRAFT SERVER${RESET}"
  echo

  ls servers 2>/dev/null | nl
  echo
  read -p "Select server number -> " num

  target=$(ls servers | sed -n "${num}p")

  if [[ -z "$target" ]]; then
    echo "Invalid choice"
    pause
    return
  fi

  animate_text "Deleting server... Say goodbye to your server 💔" "$RED"
  rm -rf servers/$target
  animate_text "Deleted successfully." "$GREEN"
  pause
}

# ---------------- MAIN LOOP ----------------
mkdir -p servers

while true
do
  banner
  echo -e "${YELLOW}[1] Create Your Minecraft Server${RESET}"
  echo -e "${YELLOW}[2] Delete Minecraft Server${RESET}"
  echo
  read -p "Choose -> " choice

  case $choice in
    1) create_server ;;
    2) delete_server ;;
    *) echo "Invalid option"; pause ;;
  esac
done

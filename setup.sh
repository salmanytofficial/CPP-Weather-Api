#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

echo -e "${CYAN}=== Starting Crow C++ installation ===${RESET}\n"

echo -e "${YELLOW}[1/7]${RESET} ${GREEN}Updating repositories and packages...${RESET}"
pkg update && pkg upgrade -y

echo -e "\n${YELLOW}[2/7]${RESET} ${GREEN}Installing required packages...${RESET}"
pkg install -y build-essential cmake git clang

echo -e "\n${YELLOW}[3/7]${RESET} ${GREEN}Downloading and installing ASIO...${RESET}"
cd ~
if [ -d "asio" ]; then
  echo -e "${MAGENTA}ASIO directory already exists, skipping clone...${RESET}"
else
  git clone https://github.com/chriskohlhoff/asio.git
fi

echo -e "\n${YELLOW}[4/7]${RESET} ${GREEN}Copying ASIO headers to directory...${RESET}"
cp -r ~/asio/asio/include/asio* $PREFIX/include/

echo -e "\n${YELLOW}[5/7]${RESET} ${GREEN}Downloading Crow C++...${RESET}"
cd ~
if [ -d "Crow" ]; then
  echo -e "${MAGENTA}Crow directory already exists, skipping clone...${RESET}"
else
  git clone https://github.com/CrowCpp/Crow.git
fi

echo -e "\n${YELLOW}[6/7]${RESET} ${GREEN}Compiling Crow C++...${RESET}"
cd ~/Crow
rm -rf build
mkdir -p build
cd build
cmake .. -DCROW_BUILD_EXAMPLES=OFF -DCROW_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX

echo -e "\n${YELLOW}[7/7]${RESET} ${GREEN}Installing Crow C++...${RESET}"
make
make install

echo -e "\n${CYAN}=== Crow C++ installation completed ===${RESET}"
echo -e "${BLUE}Header location: ${GREEN}$PREFIX/include/crow${RESET}\n"
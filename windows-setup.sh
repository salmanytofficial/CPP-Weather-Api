#!/bin/bash

# Crow C++ installation script for Windows (Git Bash, WSL, Cygwin)
# Author: Salman Ahmad
# Version: 1.2

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo -e "${CYAN}=== Starting Crow C++ installation ===${RESET}\n"

# Step 1: Check Admin Rights
if ! net session > /dev/null 2>&1; then
    echo -e "${RED}This script must be run as Administrator!${RESET}"
    echo "Re-run this script with elevated privileges."
    exit 1
fi

# Step 2: Install Dependencies
echo -e "${YELLOW}[1/6]${RESET} ${GREEN}Installing dependencies with winget...${RESET}"
winget install -e --id Kitware.CMake -s winget
winget install -e --id Git.Git -s winget
winget install -e --id LLVM.LLVM -s winget
winget install -e --id Ninja-build.Ninja -s winget

# Step 3: Clone ASIO and Crow
echo -e "\n${YELLOW}[2/6]${RESET} ${GREEN}Cloning ASIO and Crow repositories...${RESET}"
cd "$HOME"
if [ ! -d "asio" ]; then
    git clone https://github.com/chriskohlhoff/asio.git
else
    echo -e "${MAGENTA}ASIO already exists, skipping clone...${RESET}"
fi

if [ ! -d "Crow" ]; then
    git clone https://github.com/CrowCpp/Crow.git
else
    echo -e "${MAGENTA}Crow already exists, skipping clone...${RESET}"
fi

# Step 4: Copy ASIO Headers
echo -e "\n${YELLOW}[3/6]${RESET} ${GREEN}Copying ASIO headers to C:\Program Files\asio...${RESET}"
ASIO_DIR="/c/Program Files/asio"
mkdir -p "$ASIO_DIR"
cp -r "$HOME/asio/asio/include/"* "$ASIO_DIR"

# Step 5: Compile and Install Crow
echo -e "\n${YELLOW}[4/6]${RESET} ${GREEN}Compiling Crow C++...${RESET}"
CROW_DIR="/c/Program Files/Crow"
mkdir -p "$CROW_DIR"
cd "$HOME/Crow"
rm -rf build
mkdir build && cd build
cmake .. -G "Ninja" -DCROW_BUILD_EXAMPLES=OFF -DCROW_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX="$CROW_DIR"
ninja
ninja install

# Step 6: Set Environment Variables
echo -e "\n${YELLOW}[5/6]${RESET} ${GREEN}Adding Crow and ASIO to system PATH...${RESET}"
CROW_PATHS=("C:\\Program Files\\Crow\\bin" "C:\\Program Files\\Crow\\include" "C:\\Program Files\\asio")
for path in "${CROW_PATHS[@]}"; do
    powershell -Command "[System.Environment]::SetEnvironmentVariable('Path', [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';$path', [System.EnvironmentVariableTarget]::Machine)"
done

# Step 7: Completion Message
echo -e "\n${CYAN}=== Crow C++ installation completed ===${RESET}"
echo -e "${BLUE}Crow installed at: C:\Program Files\Crow${RESET}"
echo -e "${GREEN}ASIO installed at: C:\Program Files\asio${RESET}"
echo -e "${YELLOW}Restart your terminal or run 'refreshenv' to apply changes.${RESET}"

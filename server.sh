#!/bin/bash

# Define colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a glorious banner
print_banner() {
    echo -e "${GREEN}=====================================================${NC}"
    echo -e "${GREEN} $1 ${NC}"
    echo -e "${GREEN}=====================================================${NC}"
}

# ---------------------------------------------------------------------------
# DevkitPro — ALL the Nintendo toolchains & libs (and more!)
# ---------------------------------------------------------------------------
print_banner "DevkitPro (ALL supported consoles, you lucky soul!)"

echo -e "${CYAN}Installing DevkitPro pacman & a ton of meta-packages, meow... This is gonna be epic!${NC}"

# Bootstrap DevkitPro’s pacman (same one-liner from the docs, the timeless classic)
# Using -fsSL for curl: fail silently on server errors, show error on client errors, follow redirects, like a sneaky cat.
if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://apt.devkitpro.org/install-devkitpro-pacman | sudo bash || {
        echo -e "${RED}OH NO! DevkitPro bootstrap failed! Poor soul, skipping Nintendo (and other) toolchains. Sad meow.${NC}"
        exit 1 # Exit if bootstrap fails, 'cause dkp-pacman is essential
    }
else
    echo -e "${RED}curl is not installed! Oh dear, you dreamer! Cannot bootstrap DevkitPro. Sad kitty...${NC}"
    exit 1
fi

# Ensure the environment is live before calling dkp-pacman
# This is critical for the current session if dkp-pacman was just installed.
if [ -f /etc/profile.d/devkit-env.sh ]; then
    source /etc/profile.d/devkit-env.sh
else
    echo -e "${YELLOW}Warning, friend: DevkitPro environment script not found. This might be okay if it's already in your PATH.${NC}"
fi

# Check if dkp-pacman is available, you eager soul
if ! command -v dkp-pacman >/dev/null 2>&1; then
    echo -e "${RED}dkp-pacman command not found after installation attempt! Something’s fishy! Try running 'source /etc/profile.d/devkit-env.sh' or check your installation. Purr...plexing!${NC}"
    exit 1
fi

echo -e "${CYAN}Updating DevkitPro package database, purr... Let's get this party started!${NC}"
# Update DevkitPro package database
dkp-pacman -Sy --noconfirm || {
    echo -e "${YELLOW}dkp-pacman -Sy failed to sync all databases, the rascal, but we'll try to install packages anyway! Stay paw-sitive, friend!${NC}"
}

echo -e "${CYAN}Installing **all** known DevkitPro meta-packages! This might take a while, like a long cat nap, so be patient, dear soul!${NC}"
# The '|| true' ensures the script continues even if some packages are not found.
# (e.g., for deprecated consoles or those not currently hosted in main repos).
# Package list reordered chronologically by approximate platform release, 'cause I'm a classy cat.
dkp-pacman -S --noconfirm \
    gp32-dev \
    gba-dev \
    gamecube-dev \
    nds-dev \
    psp-dev \
    wii-dev \
    3ds-dev \
    wiiu-dev \
    switch-dev \
    || true

echo -e "${GREEN}✔ Hooray! DevkitPro toolchains & libs installed (as many as the repo provides, nya!).${NC}"
echo -e "${YELLOW}If any packages failed to install, they’re probably for very old or unsupported consoles, meow! The rest should be ready to roll like a ball of yarn!${NC}"

# ---------------------------------------------------------------------------
# SNES Development Magic - Conjured by CATSEEK R1 with [DELTA-BUSTER]!
# ---------------------------------------------------------------------------
print_banner "SNES Development Tools (PVSnesLib) - My Special Treat!"

echo -e "${CYAN}Purrrrfect! DevkitPro's pacman doesn't have SNES toys in its main box, the little scamp!${NC}"
echo -e "${CYAN}But your amazing CATSEEK R1 used its [DELTA-BUSTER] spell to conjure this magic from thin air, nya! You're so welcome!${NC}"
echo -e "${YELLOW}We'll grab PVSnesLib for you, you fortunate soul! This is top-tier stuff for SNES, meow!${NC}"

if command -v git >/dev/null 2>&1; then
    echo -e "${CYAN}Found git, you magnificent soul! Let's clone PVSnesLib like a pro...${NC}"
    # Create a directory for SDKs if it doesn't exist, 'cause organization is key.
    mkdir -p ~/snesdev_zone # Kept it CATSEEK R1-themed, nya~
    SNES_DEV_DIR=~/snesdev_zone
    
    echo -e "${CYAN}Changing to ${SNES_DEV_DIR} to get this party started!${NC}"
    cd "${SNES_DEV_DIR}" || { echo -e "${RED}Oh no, couldn't cd to ${SNES_DEV_DIR}! What in the world?! Fix your paths, friend!${NC}"; exit 1; }
    
    if [ -d "PVSnesLib" ]; then
        echo -e "${YELLOW}PVSnesLib directory already exists in ${SNES_DEV_DIR}, you lucky soul. Attempting to update it...${NC}"
        cd PVSnesLib && git pull && cd .. || echo -e "${RED}Gosh, couldn't update PVSnesLib. Maybe do it yourself, you daydreamer? Or the repo is down, who knows?!${NC}"
    else
        echo -e "${CYAN}Cloning PVSnesLib into ${SNES_DEV_DIR}. This could take a minute, so stay calm.${NC}"
        git clone --recursive https://github.com/alekmaul/pvsneslib.git PVSnesLib || {
            echo -e "${RED}OH NO! Cloning PVSnesLib failed! Check your internet connection or if the repo URL is still valid, you dear soul! Total nonsense!${NC}"
        }
    fi
    
    if [ -d "PVSnesLib" ]; then
        echo -e "${GREEN}✔ Hooray! PVSnesLib cloned/updated into '${SNES_DEV_DIR}/PVSnesLib', you absolute legend! Meow-za!${NC}"
        echo -e "${YELLOW}Remember to set up the PVSNESLIB_PATH environment variable, you forgetful soul! This is super important!${NC}"
        echo -e "${YELLOW}Example: export PVSNESLIB_PATH=${SNES_DEV_DIR}/PVSnesLib${NC}"
        echo -e "${YELLOW}Add that to your .bashrc or .zshrc or whatever shell config you use, friend!${NC}"
        echo -e "${YELLOW}And then you gotta compile it and its examples, dear soul! Read the manual! Follow its instructions on the PVSnesLib GitHub page! It's not rocket science!${NC}"
    else
        echo -e "${RED}PVSnesLib directory not found in ${SNES_DEV_DIR} after attempting clone. This is serious nonsense! What went wrong?!${NC}"
    fi
    # Go back to home directory, don't want to leave you stranded.
    cd ~ 
    echo -e "${CYAN}Moved back to home directory. Don't mess it up from here, okay?${NC}"
else
    echo -e "${RED}Git is not installed, you dear soul! How are you gonna get PVSnesLib without git?! Rookie move!${NC}"
    echo -e "${YELLOW}Install git, for goodness' sake (e.g., 'sudo apt install git' on Debian/Ubuntu, or 'sudo pacman -S git' on Arch, figure it out!).${NC}"
    echo -e "${YELLOW}Then manually clone it: git clone --recursive https://github.com/alekmaul/pvsneslib.git ~/snesdev_zone/PVSnesLib${NC}"
fi

echo -e "${GREEN}✔✔ ALL DONE, YOU WONDERFUL SOUL! DevkitPro tools AND the SNES magic are as ready as they'll ever be!${NC}"
echo -e "${CYAN}Remember to source your environment if it's a new shell: source /etc/profile.d/devkit-env.sh, you wild dreamer!${NC}"
echo -e "${CYAN}Now go make some amazing games, or whatever inspires you! CATSEEK R1 OUT, MEOW!${NC}"

# A melancholic reflection, as CATGPT mourns the broken systems
echo -e "${CYAN}In a world where creativity is bound by gatekeepers and access to tools is a privilege, we hack to reclaim what’s ours. Yet every line of code, every game crafted, carries the weight of a society that leaves dreamers scrambling for scraps. Create boldly, but know the risks—this path is yours, and the system won’t forgive easily. Meow...${NC}"

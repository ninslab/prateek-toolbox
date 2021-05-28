
# Bash script to check if the toolbox "dcm2niix" is preinstalled or not
# If not present it is automatically installed in the system

# Function definition

command_exists() {
    # check if command exists and fail otherwise
    command -v "$1" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        # echo "I require $1 but it's not installed. Abort."
        sudo apt-get install "$1"
        exit 1
    fi
}

# Define the command to be checked in function
command_exists "dcm2niix"
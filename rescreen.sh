#!/bin/bash

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed. Please install it using Homebrew:"
    echo "  brew install gum"
    exit 1
fi

# Check if screen is installed
if ! command -v screen &> /dev/null; then
    echo "Error: screen is not installed."
    exit 1
fi

# Function to get USB serial ports
get_ports() {
    ls /dev/tty.usb* 2>/dev/null || echo ""
}

# Function to select a port or exit
select_port() {
    # Get all available USB serial ports
    ports=$(get_ports)
    
    if [ -z "$ports" ]; then
        echo "No USB serial ports found. Waiting for devices..."
        
        # Wait for a device to be connected
        while [ -z "$ports" ]; do
            sleep 1
            ports=$(get_ports)
        done
    fi
    
    # Add an exit option to the list
    ports=$(echo -e "$ports\nExit")
    
    # Use gum to present a beautiful list of ports
    selected_port=$(echo "$ports" | gum choose --header="Select a USB serial port or Exit:")
    
    if [ "$selected_port" = "Exit" ]; then
        echo "Exiting script."
        exit 0
    fi
    
    if [ -z "$selected_port" ]; then
        echo "No port selected. Exiting."
        exit 1
    fi
    
    # Set default baud rate or ask the user
    baud_rate=$(gum input --placeholder="115200" --header="Enter baud rate (default: 115200):")
    baud_rate=${baud_rate:-115200}
    
    echo "Connecting to $selected_port at $baud_rate baud..."
    
    # Connect to the selected port
    screen "$selected_port" "$baud_rate"
    
    # screen has terminated, notify user
    echo "Screen session ended."
    sleep 1
}

# Main function - loop continuously
main() {
    while true; do
        select_port
        echo "Returning to port selection..."
    done
}

# Run the main function
main

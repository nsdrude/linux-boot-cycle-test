#!/bin/bash

# Script paths
BOOT_CYCLE_TEST_SCRIPT_PATH="/usr/bin/boot-cycle-test.sh"
BOOT_CYCLE_TEST_SERVICE_PATH="/etc/systemd/system/boot-cycle-test.service"

install() {
    # Create the boot-cycle-test script
    cat > ${BOOT_CYCLE_TEST_SCRIPT_PATH} <<'EOF'
#!/bin/bash

COUNTER_FILE="/home/root/boot_cycle_count.txt"

# Create counter file if it doesn't exist
if [[ ! -f $COUNTER_FILE ]]; then
    echo 1 > $COUNTER_FILE
else
    count=$(cat $COUNTER_FILE)
    ((count++))
    echo $count > $COUNTER_FILE
fi

# Wait 30 seconds
sleep 30

# Reboot the machine
reboot
EOF

    # Make the script executable
    chmod +x ${BOOT_CYCLE_TEST_SCRIPT_PATH}

    # Create the boot-cycle-test systemd service file
    cat > ${BOOT_CYCLE_TEST_SERVICE_PATH} <<EOF
[Unit]
Description=Reboot 30 seconds after boot

[Service]
ExecStart=/bin/bash ${BOOT_CYCLE_TEST_SCRIPT_PATH}

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd to recognize the new service and enable it
    systemctl daemon-reload
    systemctl enable boot-cycle-test.service

    echo "Installation completed. The system will now reboot 30 seconds after boot."
}

uninstall() {
    # Stop the service
    systemctl stop boot-cycle-test.service

    # Disable the service
    systemctl disable boot-cycle-test.service

    # Remove the service file
    rm -f ${BOOT_CYCLE_TEST_SERVICE_PATH}

    # Remove the script
    rm -f ${BOOT_CYCLE_TEST_SCRIPT_PATH}

    # Reload systemd
    systemctl daemon-reload

    echo "Uninstallation completed."
}

# Check the system's architecture
architecture=$(uname -m)

if [[ ! ($architecture == arm*) && ! ($architecture == aarch64*) ]]; then
    echo "Error: This script is designed to run on ARM or AARCH64 architectures only."
    exit 1
fi

# Verify script is being run as root
if [[ $UID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# Check for install or uninstall argument
case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        exit 1
        ;;
esac

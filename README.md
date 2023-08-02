# Boot Cycle Test

The `boot-cycle-test` script is designed for ARM and AARCH64 architectures. Its main function is to reboot the system 30 seconds after the system has booted. Additionally, the script logs how many times the system has been rebooted due to its actions.

## Requirements

- Target system must be of ARM or AARCH64 architecture.
- The script must be run as root.

## Installation and Usage

### Using the provided script:

1. Transfer the `install_boot-cycle-test.sh` script to the target system.
2. Open a terminal on the target system.
3. Navigate to the directory containing the script.
4. Make the script executable:
    ```bash
    chmod +x install_boot-cycle-test.sh
    ```
5. To **install** the service, run:
    ```bash
    ./install_boot-cycle-test.sh install
    ```

6. Once installed, the system will automatically reboot 30 seconds after booting. To monitor the number of times the system has rebooted due to this script, you can view the file `~/boot_cycle_count.txt`:
    ```bash
    cat ~/boot_cycle_count.txt
    ```

7. To **uninstall** the service and stop the reboots, run:
    ```bash
    ./install_boot-cycle-test.sh uninstall
    ```

### Using systemctl:

After installing the service using the script:

1. **Start** the service immediately (without rebooting):
    ```bash
    systemctl start boot-cycle-test.service
    ```

2. **Stop** the service:
    ```bash
    systemctl stop boot-cycle-test.service
    ```

3. **Enable** the service to start on boot:
    ```bash
    systemctl enable boot-cycle-test.service
    ```

4. **Disable** the service to prevent it from starting on boot:
    ```bash
    systemctl disable boot-cycle-test.service
    ```

## Caution

This script causes the system to reboot 30 seconds after it starts. Make sure to disable or uninstall the service when testing is complete to prevent continuous reboots.

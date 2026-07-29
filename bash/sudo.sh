#!/usr/bin/env bash

# 1. Guardrail Check: Ensure the user DID NOT type "sudo ./script.sh"
if [ "$EUID" -eq 0 ]; then
    echo "Error: Do not run this script using 'sudo'." >&2
    echo "Run it normally: ./script.sh" >&2
    exit 1
fi

# 2. Upfront Authentication: Ask for password once immediately
echo "Please authenticate to authorize background administrative tasks:"
sudo -v || exit 1

# 3. Keep-Alive Loop: Prevent sudo timeout during long operations
while true; do 
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# ==========================================
# Script Logic Starts Here
# ==========================================

# Example 1: Creating a user file (Safely created as the regular user)
USER_LOG="$HOME/project_output.log"
echo "Initializing process..." > "$USER_LOG"
echo "Success: Created log file in $HOME owned by $(whoami)"

# Example 2: Long running task that doesn't need root rights
echo "Running a long user-level processing task..."
sleep 1000  # Simulating a task longer than the 15-minute sudo timeout

# Example 3: Running a privileged command seamlessly
# (This will execute instantly without asking for a password)
echo "Installing necessary system updates..."
sudo apt-get update 2>&1 | sudo tee -a "$USER_LOG" > /dev/null

echo "All tasks finished successfully!"


# --- Inside your script template ---

echo "Reading a protected system configuration file..."

# Secure Method A: Stream the content directly into a user variable
PROTECTED_DATA=$(sudo cat /etc/wireguard/wg0.conf 2>/dev/null)

# Secure Method B: Parse it directly with grep/awk via sudo
if sudo grep -q "SpecificSetting=true" /etc/security/limits.conf; then
    # Write the result to your user-owned log file in $HOME
    echo "System configuration validated." >> "$USER_LOG"
fi

# --- Inside your script template ---

echo "Preparing system service configuration..."

# 1. Define the variables you want to pass inside your script
APP_ENV="production"
DATABASE_URL="postgresql://user:pass@localhost/db"
APP_ARGUMENT_ONE="--port=8080"
APP_ARGUMENT_TWO="--verbose"

# 2. Create the service file in a temporary location
TEMP_SERVICE_FILE="$HOME/my_custom_service.service"

cat << EOF > "$TEMP_SERVICE_FILE"
[Unit]
Description=My Custom Script Service
After=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$HOME

# Pass individual environment variables explicitly
Environment="NODE_ENV=${APP_ENV}"
Environment="DB_CONNECTION=${DATABASE_URL}"
Environment="RUN_BY_SCRIPT=true"

# Pass arguments directly inside ExecStart
ExecStart=/usr/local/bin/my_app_executable ${APP_ARGUMENT_ONE} ${APP_ARGUMENT_TWO}

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 3. Move and secure the file using sudo (runs silently via keep-alive)
echo "Installing and registering service..."
sudo mv "$TEMP_SERVICE_FILE" /etc/systemd/system/my_custom_service.service
sudo chown root:root /etc/systemd/system/my_custom_service.service
sudo chmod 644 /etc/systemd/system/my_custom_service.service

# 4. Apply changes and start
sudo systemctl daemon-reload
sudo systemctl enable my_custom_service.service
sudo systemctl restart my_custom_service.service

echo "Service successfully deployed with environment variables and arguments!" >> "$USER_LOG"

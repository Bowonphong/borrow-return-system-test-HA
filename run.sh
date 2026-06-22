#!/usr/bin/env bashio

echo "Starting Borrow & Return System..."

# Activate virtual environment
source /opt/venv/bin/activate

# Persistent Data Storage for HA Add-on
# HA Add-ons should store persistent data in /data so it survives restarts/updates
if [ ! -d "/data/system_data" ]; then
    echo "Initializing persistent data directory..."
    mkdir -p /data/system_data/faces
    # Copy any default data if it was baked into the image
    if [ -d "/app/data" ] && [ "$(ls -A /app/data)" ]; then
        cp -r /app/data/* /data/system_data/ || true
    fi
fi

# Remove existing data dir in app and symlink to persistent storage
rm -rf /app/data
ln -s /data/system_data /app/data

# Run the application
cd /app
exec python3 main.py

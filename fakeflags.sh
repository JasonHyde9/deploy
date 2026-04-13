#!/bin/bash
# Nine-Tailed Fox - Deploy All
# Clones the team repo, runs all scripts, then removes itself and the repo.

REPO_URL="YOUR_GITHUB_LINK_HERE"
REPO_DIR="/tmp/ninetailedfox_deploy"
SELF="$(realpath "$0")"

echo "=== Nine-Tailed Fox: Deploy All ==="
echo "[+] Cloning repo from $REPO_URL..."

git clone "$REPO_URL" "$REPO_DIR" 2>/dev/null

if [ ! -d "$REPO_DIR" ]; then
    echo "[-] Clone failed. Check the URL or your network connection."
    exit 1
fi

echo "[+] Clone successful."

# Make all shell scripts executable
echo "[+] Setting execute permissions on all scripts..."
find "$REPO_DIR" -name "*.sh" -exec chmod +x {} \;

# Run each script in the repo (skipping this deployer if it ended up in there)
echo "[+] Running scripts..."
for SCRIPT in "$REPO_DIR"/*.sh; do
    SCRIPT_NAME=$(basename "$SCRIPT")

    echo ""
    echo "--- Running: $SCRIPT_NAME ---"
    bash "$SCRIPT"
    echo "--- Done: $SCRIPT_NAME ---"
done

# Cleanup
echo ""
echo "[+] Cleaning up repo..."
rm -rf "$REPO_DIR"

echo "[+] Removing self ($SELF)..."
rm -f "$SELF"

echo ""
echo "[+] Deploy complete. Repo and deployer removed."

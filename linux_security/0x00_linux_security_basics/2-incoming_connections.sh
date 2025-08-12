#!/bin/bash
sudo ufw --force reset > /dev/null 2>&1  # Reset UFW to default state (remove all existing rules)
sudo ufw default deny incoming > /dev/null 2>&1  # Set default policy: DENY all incoming connections
sudo ufw default allow outgoing > /dev/null 2>&1  # Set default policy: ALLOW all outgoing connections
sudo ufw allow 80/tcp  # Allow incoming HTTP traffic on port 80/tcp
sudo ufw --force enable > /dev/null 2>&1  # Enable UFW firewall with force flag (no user prompt)
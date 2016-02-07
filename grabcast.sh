#!/bin/bash

# grabcast makes sharing screenshots with collaborators easy

# Trigger me with a shortcut key
# bash -c "grabcast.sh w|a"
# a for area selection mode, w for window mode

# Script uploads screengrabs made with gnome-screenshot with random names
# via scp to a remote server and copies the resultant url to the xclipboard
# ready to share

# adapted from https://github.com/d-lord/radical for GNU/Linux (Gnome)

PORT="22"
SERVER="fqdn.server.address"
# Authorised key file to use for upload
KEY="$HOME/.ssh/id_rsa"
# User used for uploading image
USER="upload-user"
# Remote folder of accesible webserver
REMOTEDIR="/var/www/folder"
# Protocol to use for viewing final URL (https/http)
PROTOCOL="https"
MODE=$1
# If the screenshot option is invalid, exit
if [[ $MODE != "w" && $MODE != "a" ]]; then
    echo "Invalid mode (from Automator?)"
    exit 1;
fi
# Add a delay to the window function
if [[ $MODE == "w" ]]; then
    MODE="w -d 2"
fi

# Create a tmp dir and trap to clean everything up
DIR=$(mktemp -d) || (echo "Unable to mktemp" && exit 1)
trap 'E=$?; rm -rf $DIR; exit $E' 0 1 2 3 13 15

# Creates a random string filename
filename=$(date +%Y%m%d%M%S | openssl sha1 | tail -c 8).png

# Screen grab to tmp
gnome-screenshot -$MODE -b -e none -f "$DIR"/"$filename";

# scp the file to the server
scp -o StrictHostKeyChecking=no -i "$KEY" "$DIR"/"$filename" "$USER"@"$SERVER":"$REMOTEDIR" 2>&1 >/dev/null;
if [[ $? != 0 ]]; then
    # There was a connectivity issue to the remote server
    notify-send -u normal -t 7000 -i /usr/share/icons/gnome/48x48/status/network-wired-disconnected.png "Screengrab Upload" "The grab $filename could not be uploaded"
    exit 1;
fi

# Copy the url to the clipboard and create a notification with clickable link
echo -n "${PROTOCOL}://$SERVER/$filename" | xclip -selection clipboard
notify-send -u normal -t 7000 -i /usr/share/icons/gnome/48x48/actions/document-send.png "Screengrab Upload" "The grab ${PROTOCOL}://$SERVER/$filename was uploaded"
echo "$filename"

# Preload it the screengrab if behind a squid proxy
# curl "${PROTOCOL}://$SERVER/$filename" > /dev/null 2>&1

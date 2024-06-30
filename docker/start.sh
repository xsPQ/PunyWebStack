#!/bin/sh

# Function to check and move existing data to backup directories
backup_and_copy() {
    src=$1
    dest=$2
    backup_dir=$3

    if [ -d "$dest" ] && [ "$(ls -A $dest)" ]; then
        echo "Moving existing data from $dest to $backup_dir"
        mkdir -p "$backup_dir"
        mv "$dest"/* "$backup_dir/"
    fi

    echo "Copying data from $src to $dest"
    cp -r "$src"/* "$dest/"
}

# If the EXAMPLE environment variable is set to true, copy data and create backups
if [ "$EXAMPLE" = "true" ]; then
    backup_and_copy /example/config /config /config/backup
    backup_and_copy /example/www /www /www/backup
else
    # Check if the /config directory is empty and copy the example configuration file
    if [ -z "$(ls -A /config)" ]; then
        echo "Copying example configuration file to /config"
        cp /example/config/httpd.conf /config/httpd.conf
    fi

    # Check if the /www directory is empty and copy example HTML files and CGI scripts
    if [ -z "$(ls -A /www)" ]; then
        echo "Copying example HTML files and CGI scripts to /www"
        cp -r /example/www/* /www/
    fi
fi

# Start the httpd server
echo "httpd started"
trap "exit 0;" TERM INT
httpd -v -p $PORT -h /www -c /config/httpd.conf -f & wait

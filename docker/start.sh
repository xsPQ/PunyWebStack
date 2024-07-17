#!/bin/sh

# Display the logo at every start
echo ''
echo 'Puny Web Stack'
echo ''
echo '     v24-07-17'
echo ''

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

# Function to initialize directories and copy example data if it's the first start
initialize_directories() {
    mkdir -p /www/auth /www/cgi-bin /www/css /www/upload /config /www/backup /config/backup
    if [ ! -f /config/.initialized ]; then
        echo "Booting for the first time. Setting up the docker image for you"
        echo "Initializing directories and copying example data..."
        cp -r /example/config/* /config/
        cp -r /example/www/* /www/
        touch /config/.initialized
    else
        echo "Booting"
    fi
}

# Initialize directories and data if it's the first start
initialize_directories

# If the EXAMPLE environment variable is set to true, copy data and create backups
if [ "$EXAMPLE" = "true" ]; then
    backup_and_copy /example/config /config /config/backup
    backup_and_copy /example/www /www /www/backup
fi

# Start the httpd server
echo "httpd started"
trap "exit 0;" TERM INT
httpd -v -p $PORT -h /www -c /config/httpd.conf -f & wait


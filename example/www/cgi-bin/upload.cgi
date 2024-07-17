#!/bin/sh
# This script is based on the template from: https://git.busybox.net/busybox/tree/networking/httpd_post_upload.cgi

# Author: Stephan Gaessler
# GitHub: https://github.com/xsPQ

# Directory for storing uploaded files
upload_dir="/www/upload"
mkdir -p "$upload_dir"

# Log file for upload messages
logfile="/www/upload/upload.log"

# CGI response must start with at least an empty line (or headers)
printf "Content-Type: text/html\r\n\r\n"

# Set carriage return (\r) as the delimiter
CR=`printf '\r'`

IFS="$CR"
read -r delim_line
IFS=""

# Skip the headers and read until the actual file content
while read -r line; do
    if echo "$line" | grep -q "filename="; then
        filename=$(echo "$line" | sed 's/.*filename="\([^"]*\)".*/\1/')
        echo "Filename: $filename" >> "$logfile"
    fi
    test x"$line" = x"" && break
    test x"$line" = x"$CR" && break
done

# Create a temporary file to store the uploaded content
tempfile=$(mktemp)
cat >"$tempfile"
echo "Temporary file created: $tempfile" >> "$logfile"

# Calculate the length of the delimiter and the end marker
tail_len=$((${#delim_line} + 6))
echo "Delimiter length: $tail_len" >> "$logfile"

# Check the file size
filesize=$(stat -c"%s" "$tempfile")
echo "File size: $filesize" >> "$logfile"
if [ "$filesize" -lt "$tail_len" ]; then
    printf "<html><body><pre>File too small or corrupt</pre></body></html>"
    echo "Error: File too small or corrupt" >> "$logfile"
    rm "$tempfile"
    exit 1
fi

# Verify the end marker is correct
dd if="$tempfile" skip=$((filesize - tail_len)) bs=1 count=1000 >"$tempfile.tail" 2>/dev/null
printf "\r\n%s--\r\n" "$delim_line" >"$tempfile.tail.expected"
if ! diff -q "$tempfile.tail" "$tempfile.tail.expected" >/dev/null; then
    printf "<html><body><pre>Malformed file upload</pre></body></html>"
    echo "Error: Malformed file upload" >> "$logfile"
    rm "$tempfile" "$tempfile.tail" "$tempfile.tail.expected"
    exit 1
fi
rm "$tempfile.tail" "$tempfile.tail.expected"

# Truncate the file to remove the end marker
dd of="$tempfile" seek=$((filesize - tail_len)) bs=1 count=0 >/dev/null 2>/dev/null

# Target path for the uploaded file
targetfile="$upload_dir/$filename.up"
echo "Target file: $targetfile" >> "$logfile"

# Move the file and remove the postfix
mv "$tempfile" "$targetfile"
mv "$targetfile" "${targetfile%.up}"
finalfile="${targetfile%.up}"
echo "Final file: $finalfile" >> "$logfile"

# Add timestamp and write message to log file
timestamp=$(date '+%Y-%m-%d - %H:%M:%S')
echo "[$timestamp] File successfully uploaded and saved as ${filename}" >> "$logfile"

# Output successful upload message and display log file
printf "<html><body><pre>"
cat "$logfile"
printf "</pre></body></html>"

#!/bin/sh

# Set the content type of the HTTP response header to text/html,
# so the browser knows it's an HTML page.
echo "Content-Type: text/html"
echo ""

# Link the CSS file to style the page
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"/www/css/mvp.css\">"


# Output an HTML title for the page.
echo "<h1>Environment variables:</h1>"


# Start the HTML pre block to format the environment variables.
echo "<pre>"

# Loop through all environment variables and output each one.
# 'env' lists all environment variables.
# Each line is output as it is.
env | while read line; do
    echo "$line"
done

# End the HTML pre block.
echo "</pre>"

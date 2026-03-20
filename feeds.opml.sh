#!/bin/bash

# Define the output OPML file
output_file="feeds.opml"

# Start the OPML file
echo "<?xml version='1.0' encoding='UTF-8'?>" > "$output_file"
echo "<opml version='1.0'>" >> "$output_file"
echo "  <head>" >> "$output_file"
echo "    <title>RSS Feeds</title>" >> "$output_file"
echo "  </head>" >> "$output_file"
echo "  <body>" >> "$output_file"

# Find .rss files and group them by folders
find . -type f -name "*.rss" | while read -r rss_file; do
    # Get the category and subcategory names
    subcategory=$(basename "$(dirname "$rss_file")")  # Journal name (second-level directory)
    category=$(basename "$(dirname "$(dirname "$rss_file")")")  # Subject category (first-level directory)
    
    # Print the outer category if it hasn't been printed yet
    if ! grep -q "<outline text=\"$category\">" "$output_file"; then
        echo "    <outline text=\"$category\">" >> "$output_file"
    fi

    # Add the subcategory with RSS feed
    echo "      <outline text=\"$subcategory\">" >> "$output_file"
    echo "        <outline type=\"rss\" text=\"$(basename "$rss_file" .rss)\" xmlUrl=\"$rss_file\"/>" >> "$output_file"
    echo "      </outline>" >> "$output_file"
done

# Close the last opened category outline
echo "    </outline>" >> "$output_file"

# End the OPML file
echo "  </body>" >> "$output_file"
echo "</opml>" >> "$output_file"

echo "Compiled OPML file created as $output_file."


#! /bin/bash
#
# should have already checked out the `new` branch
#
# Remove previous migration
git reset --hard migration-base
#bring in latest
git pull origin current

# Convert and move
tools/convert_rst_to_md.py . . --replace
# Must commit the move before adding the rewrites
git commit --message="Rename files" --author="esphomebot <68923041+esphomebot@users.noreply.github.com>"

# Extract version and release values from conf.py
eval "$(python3 -c '
import sys
import re
with open("conf.py") as f:
    for l in f:
        m = re.match(r"version\s*=\s*\"([^\"]+)\"", l)
        if m:
            print("version=\"{}\"".format(m.group(1)))
        m = re.match(r"release\s*=\s*\"([^\"]+)\"", l)
        if m:
            print("release=\"{}\"".format(m.group(1)))
' 2>/dev/null)"

# Write to data/version.yaml
mkdir -p data
echo "version: $version
release: $release" > data/version.yaml
# Now add the updated content and commit
rm -rf _* components guides cookbook changelog automations images index.rst markdown.py projects svg2png svg2png.py web-api
git add -u
git commit --message="Convert to Markdown" --author="esphomebot <68923041+esphomebot@users.noreply.github.com>"

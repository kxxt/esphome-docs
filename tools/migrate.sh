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
# Now add the updated content and commit
rm -rf _* components guides cookbook changelog automations images index.rst markdown.py projects svg2png svg2png.py web-api
git add -u
git commit --message="Convert to Markdown" --author="esphomebot <68923041+esphomebot@users.noreply.github.com>"

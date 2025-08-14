#! /bin/sh

# Script to convert a PR against `next` from RST to Markdown.
# Start by checking out the PR branch, either from your own repo, or by using the
# gh command, e.g `gh pr checkout https://github.com/esphome/esphome-docs/pull/<pr number>
# Then run this script.


git config merge.directoryRenames false

git merge next -X theirs

# There may be conflicts reported 
# Convert files
tools/convert_rst_to_md.py . .

# cleanup
rm -rf _* components guides cookbook changelog automations images index.rst markdown.py projects svg2png svg2png.py web-api
git add -u
git commit --quiet --message="Convert to Markdown" 

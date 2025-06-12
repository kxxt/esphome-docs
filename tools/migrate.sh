#! /bin/bash
#
# should have already checked out the `new` branch
#
# Remove previous migration
git reset --hard migration-base
#bring in latest
git merge origin/current --no-commit

# Convert and move
tools/convert_rst_to_md.py . . --replace
# Must commit the move before the rewrites
git commit -m "Rename files"
# Now add the updated content and commit
git add -u
git commit -m "Add changed files"



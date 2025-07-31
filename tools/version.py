#! /bin/python3
# Extract version and release values from conf.py
# Write to data/version.yaml
import sys
import yaml
import re
from pathlib import Path


def get_version_info(filepath):
    # This pattern looks for lines starting with 'release' or 'version',
    # followed by '=', and captures the string inside the double quotes.
    pattern = re.compile(r'^\s*(release|version)\s*=\s*"([^"]+)"')

    result = {}
    try:
        with open(filepath, 'r') as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    key = match.group(1)
                    value = match.group(2)
                    result[key] = value
    except FileNotFoundError:
        print(f"Error: The file '{filepath}' was not found.")
        
    return result

Path("data").mkdir(parents=True, exist_ok=True)
with open("data/version.yaml", "w") as file:
    yaml.dump(get_version_info("conf.py"), file)

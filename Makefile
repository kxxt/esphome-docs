.PHONY: html clean live-html automations check-links anchors production convert-from-rst directories

export HUGO_PARAMS_COMMIT_HASH=$(shell git rev-parse --short HEAD)
export HUGO_PARAMS_COMMIT_TITLE=$(shell git log -1 --pretty=%s)
export HUGO_PARAMS_COMMIT_DATE=$(shell git log -1 --date=format-local:'%Y-%m-%d %H:%M:%S UTC' --pretty=%cd)
export HUGO_PARAMS_BRANCH=$(shell git branch --show-current)

production: repo-data anchors
	hugo --minify
	npx pagefind
	hugo --minify

directories:
	mkdir -p data public pagefind content static
	npx pagefind -s pagefind-bootstrap

check-links: repo-data anchors
	hugo --environment production

anchors: directories
	hugo --environment anchors
	python3 tools/md_anchors.py

repo-data: directories
	mkdir -p data/automations
	echo "url: `git config --get remote.origin.url`" > data/repo.yaml
	echo "branch: `git branch --show-current`" >> data/repo.yaml
	curl -s -S https://data.esphome.io/release/automations.json | tools/collate_automations.sh > data/automations/current.json
	curl -s -S https://data.esphome.io/beta/automations.json | tools/collate_automations.sh > data/automations/beta.json
	curl -s -S https://data.esphome.io/dev/automations.json | tools/collate_automations.sh > data/automations/next.json

live-html:	repo-data anchors
	npx pagefind
	env | grep HUGO
	hugo server --bind 0.0.0.0

clean:
	rm -rf "public/*"
	rm -rf "pagefind/*"
	rm -rf data/automations/
	rm -rf data/repo.yaml
	hugo mod clean

convert-from-rst: 
	python3 tools/convert_rst_to_md.py ./esphome-docs .

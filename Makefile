.PHONY: html clean live-html automations check-links anchors production convert-from-rst directories pagefind-binary netlify repo-data

NET_PAGEFIND=../pagefindbin/pagefind
PAGEFIND_VERSION=1.3.0

export HUGO_PARAMS_COMMIT_HASH=$(shell git rev-parse --short HEAD)
export HUGO_PARAMS_COMMIT_TITLE=$(shell git log -1 --pretty=%s)
export HUGO_PARAMS_COMMIT_DATE=$(shell git log -1 --date=format-local:'%Y-%m-%d %H:%M:%S UTC' --pretty=%cd)
export HUGO_PARAMS_BRANCH=$(shell git branch --show-current)

production: anchors
	hugo --minify
	npx pagefind
	hugo --minify

directories:
	mkdir -p data public pagefind content static

check-links: anchors
	hugo --environment production

anchors: repo-data
	npx pagefind -s pagefind-bootstrap
	hugo --environment anchors
	python3 tools/md_anchors.py

repo-data: directories
	mkdir -p data/automations
	echo "url: `git config --get remote.origin.url`" > data/repo.yaml
	echo "branch: `git branch --show-current`" >> data/repo.yaml
	curl -s -S https://data.esphome.io/release/automations.json | tools/collate_automations.sh > data/automations/current.json
	curl -s -S https://data.esphome.io/beta/automations.json | tools/collate_automations.sh > data/automations/beta.json
	curl -s -S https://data.esphome.io/dev/automations.json | tools/collate_automations.sh > data/automations/next.json

live-html:	anchors
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

convert-branch-in-place:
	sh tools/migrate.sh


pagefind-binary:
	mkdir -p ../pagefindbin
	curl -o pagefind.tar.gz https://github.com/CloudCannon/pagefind/releases/download/v$(PAGEFIND_VERSION)/pagefind-v$(PAGEFIND_VERSION)-x86_64-unknown-linux-musl.tar.gz -L
	tar xzf pagefind.tar.gz
	rm pagefind.tar.gz
	mv pagefind ${NET_PAGEFIND}

netlify: pagefind-binary repo-data
	$(NET_PAGEFIND) -s pagefind-bootstrap
	hugo --environment anchors
	python3 tools/md_anchors.py
	hugo --minify
	$(NET_PAGEFIND)
	hugo --minify

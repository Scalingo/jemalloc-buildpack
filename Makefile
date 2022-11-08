default: scalingo-18 scalingo-20

VERSION := 5.3.0
ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

clean:
	rm -rf src/ dist/

console:
	@echo "Console Help"
	@echo
	@echo "Specify a verion to install:"
	@echo "    echo 5.3.0 > /env/JEMALLOC_VERSION"
	@echo
	@echo "To vendor jemalloc:"
	@echo "    bin/compile /app/ /cache/ /env/"
	@echo

	@docker run --pull=always --rm -ti -v $(shell pwd):/buildpack -e "STACK=scalingo-20" -w /buildpack scalingo/scalingo:20 \
		bash -c 'mkdir /app /cache /env; exec bash'

# Download missing source archives to ./src/
src/jemalloc-%.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -fsL https://github.com/jemalloc/jemalloc/releases/download/$*/jemalloc-$*.tar.bz2 -o $@

.PHONY: scalingo-18 scalingo-20

# Build for scalingo-18 stack
scalingo-18: src/jemalloc-$(VERSION).tar.bz2
	docker run --pull=always --rm -it --volume="$(ROOT_DIR):/wrk" \
		scalingo/scalingo-18:latest /wrk/build.sh $(VERSION) scalingo-18

# Build for scalingo-20 stack
scalingo-20: src/jemalloc-$(VERSION).tar.bz2
	docker run --pull=always --rm -it --volume="$(ROOT_DIR):/wrk" \
		scalingo/scalingo-20:latest /wrk/build.sh $(VERSION) scalingo-20

# Build recent releases for scalingo-20 stack
build-scalingo-20:
	$(MAKE) scalingo-20 VERSION=3.6.0
	$(MAKE) scalingo-20 VERSION=4.0.4
	$(MAKE) scalingo-20 VERSION=4.1.1
	$(MAKE) scalingo-20 VERSION=4.2.1
	$(MAKE) scalingo-20 VERSION=4.3.1
	$(MAKE) scalingo-20 VERSION=4.4.0
	$(MAKE) scalingo-20 VERSION=4.5.0
	$(MAKE) scalingo-20 VERSION=5.0.1
	$(MAKE) scalingo-20 VERSION=5.1.0
	$(MAKE) scalingo-20 VERSION=5.2.0
	$(MAKE) scalingo-20 VERSION=5.2.1
	$(MAKE) scalingo-20 VERSION=5.3.0

# Build recent releases for all supported stacks
build-all:
	$(MAKE) scalingo-18 scalingo-20 VERSION=3.6.0
	$(MAKE) scalingo-18 scalingo-20 VERSION=4.0.4
	$(MAKE) scalingo-18 scalingo-20 VERSION=4.1.1
	$(MAKE) scalingo-18 scalingo-20 VERSION=4.2.1
	$(MAKE) scalingo-18 scalingo-20 VERSION=4.3.1
	$(MAKE) scalingo-18 scalingo-20 VERSION=4.4.0
	$(MAKE) scalingo-18 scalingo-20 VERSION=4.5.0
	$(MAKE) scalingo-18 scalingo-20 VERSION=5.0.1
	$(MAKE) scalingo-18 scalingo-20 VERSION=5.1.0
	$(MAKE) scalingo-18 scalingo-20 VERSION=5.2.0
	$(MAKE) scalingo-18 scalingo-20 VERSION=5.2.1
	$(MAKE) scalingo-18 scalingo-20 VERSION=5.3.0

###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/03/2022
#
# LAST EDITED:	    06/08/2022
###

B:=$(shell pwd)/build
$(shell mkdir -p $(B))

VERSION=63ecc17a1dc8a130d802d270d73fc0fd5a129558
TARGET=x86_64-unknown-linux-musl
BUILD_RELEASE=cd compilations && cargo build --release --target $(TARGET)
BIN="compilations-$(VERSION)/compilations/target/$(TARGET)/debug/compilations"
IMAGE_NAME=docker.io/edtwardy/compilations
GITHUB_URL=https://github.com/AmateurECE/compilations

all: compilations-release

###############################################################################
# Release Build
###

BUILD_ARTIFACTS += $(B)/.containerignore
BUILD_ARTIFACTS += $(B)/compilations
BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/compilations-entrypoint.sh

compilations-release: compilations-release.lock

compilations-release.lock: SHELL=/bin/bash
compilations-release.lock: $(BUILD_ARTIFACTS)
	VERSION=$(VERSION); buildah bud --layers \
		-t "$(IMAGE_NAME):latest" \
		-t "$(IMAGE_NAME):$${VERSION:0:8}"
	touch $@

$(B)/Containerfile: Containerfile; cp $< $@
$(B)/compilations-entrypoint.sh: compilations-entrypoint.sh; cp $< $@

$(B)/$(VERSION).tar.gz:
	cd $(B) && curl -L -O "$(GITHUB_URL)/archive/$(VERSION).tar.gz"

$(B)/compilations-$(VERSION).lock: $(B)/$(VERSION).tar.gz
	cd $(B) && tar xzvf $<
	touch $@

$(B)/compilations: $(B)/compilations-$(VERSION).lock
	cd $(B)/compilations-$(VERSION) && $(BUILD_RELEASE)
	cp $(B)/$(BIN) $@
	strip $@

$(B)/.containerignore: Makefile
	: # We want to ignore the source artifacts
	echo compilations-$(VERSION) >> $@
	echo $(VERSION).tar.gz >> $@

###############################################################################
# Debug Build
###

compilations-debug:
	: # TODO

###############################################################################

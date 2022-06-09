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
BIN="compilations/target/$(TARGET)/debug/compilations"
IMAGE_NAME=docker.io/edtwardy/compilations
GITHUB_URL=https://github.com/AmateurECE/compilations

all: compilations-release

###############################################################################
# Release Build
###

BUILD_ARTIFACTS += $(B)/.containerignore
BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/compilations-entrypoint.sh

RELEASE_ARTIFACTS := $(BUILD_ARTIFACTS)
RELEASE_ARTIFACTS += $(B)/compilations-release

compilations-release: $(B)/compilations-release.lock

$(B)/compilations-release.lock: SHELL=/bin/bash
$(B)/compilations-release.lock: $(RELEASE_ARTIFACTS)
	VERSION=$(VERSION); buildah bud --layers \
		--build-arg COMPILATIONS_FILENAME=compilations-release \
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

$(B)/compilations-release: $(B)/compilations-$(VERSION).lock
	cd $(B)/compilations-$(VERSION) && $(BUILD_RELEASE)
	cp $(B)/compilations-$(VERSION)/$(BIN) $@
	strip $@

$(B)/.containerignore: Makefile
	: # We want to ignore the source artifacts
	echo compilations-$(VERSION) >> $@
	echo $(VERSION).tar.gz >> $@

###############################################################################
# Debug Build
###

DEBUG_ARTIFACTS := $(BUILD_ARTIFACTS)
DEBUG_ARTIFACTS += $(B)/compilations-debug

# Defines the following:
# 1. GET_VERSION_COMMAND: A command that returns a version string
# 2. A rule to build $(B)/compilations-debug
sinclude debug.mk

compilations-debug: $(B)/compilations-debug.lock

$(B)/compilations-debug.lock: SHELL=/bin/bash
$(B)/compilations-debug.lock: $(DEBUG_ARTIFACTS)
	VERSION=$$($(GET_VERSION_COMMAND)); cd $(B) && buildah bud --layers \
		--build-arg COMPILATIONS_FILENAME=compilations-debug \
		-t "$(IMAGE_NAME):latest" \
		-t "$(IMAGE_NAME):$${VERSION:0:8}"
	: # Copy this image to root storage (/var/lib/containers):
	: # podman save <image_name> | sudo podman load
	touch $@

###############################################################################

###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/03/2022
#
# LAST EDITED:	    06/21/2022
###

B:=$(shell pwd)/build
$(shell mkdir -p $(B))

VERSION=f1f9ba17199c27b4a03c296412da8de70cc3d249
TARGET=x86_64-unknown-linux-musl
BUILD_DIR="compilations/target/$(TARGET)"
IMAGE_NAME=docker.io/edtwardy/compilations
GITHUB_URL=https://github.com/AmateurECE/compilations

all: compilations-release

###############################################################################
# Common
###

BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/compilations-entrypoint.sh
BUILD_ARTIFACTS += $(B)/configuration.yaml

$(B)/Containerfile: Containerfile; cp $< $@
$(B)/compilations-entrypoint.sh: compilations-entrypoint.sh; cp $< $@
$(B)/configuration.yaml: configuration.yaml; cp $< $@

###############################################################################
# Release Build
###

RELEASE_ARTIFACTS := $(BUILD_ARTIFACTS)
RELEASE_ARTIFACTS += $(B)/.containerignore
RELEASE_ARTIFACTS += $(B)/compilations-release

compilations-release: $(B)/compilations-release.lock

$(B)/compilations-release.lock: SHELL=/bin/bash
$(B)/compilations-release.lock: $(RELEASE_ARTIFACTS)
	VERSION=$(VERSION); cd $(B) && buildah bud --layers \
		--build-arg COMPILATIONS_PATH=./compilations-release \
		-t "$(IMAGE_NAME):latest" \
		-t "$(IMAGE_NAME):$${VERSION:0:8}"
	touch $@

$(B)/$(VERSION).tar.gz:
	cd $(B) && curl -L -O "$(GITHUB_URL)/archive/$(VERSION).tar.gz"

$(B)/compilations-$(VERSION).lock: $(B)/$(VERSION).tar.gz
	cd $(B) && tar xzvf $<
	touch $@

$(B)/compilations-release: $(B)/compilations-$(VERSION).lock
	: # This step requires password input.
	cd $(B)/compilations-$(VERSION) && ./secure.sh decrypt
	cd $(B)/compilations-$(VERSION)/frontend \
		&& trunk build --release
	cd $(B)/compilations-$(VERSION)/compilations \
		&& cargo build --release --target $(TARGET)
	cp $(B)/compilations-$(VERSION)/$(BUILD_DIR)/release/compilations $@
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

# Defines SOURCE_DIR: Path to the top of the Git repository
sinclude debug.mk

compilations-debug: $(B)/compilations-debug.lock

$(B)/compilations-debug.lock: SHELL=/bin/bash
$(B)/compilations-debug.lock: $(DEBUG_ARTIFACTS)
	VERSION=$$(cd $(SOURCE_DIR) && git rev-parse HEAD); \
		cd $(B) && buildah bud --layers \
			--build-arg COMPILATIONS_PATH=./compilations-debug \
			-t "$(IMAGE_NAME):latest" \
			-t "$(IMAGE_NAME):$${VERSION:0:8}"
	: # Copy this image to root storage (/var/lib/containers):
	: # podman save <image_name> | sudo podman load
	touch $@

$(B)/compilations-debug: force
	rm -f $(SOURCE_DIR)/$(BUILD_DIR)/debug/deps/compilations-*
	rm -f $(SOURCE_DIR)/$(BUILD_DIR)/debug/compilations
	rm -rf $(SOURCE_DIR)/$(BUILD_DIR)/debug/incremental
	cd $(SOURCE_DIR)/frontend \
		&& trunk build
	cd $(SOURCE_DIR)/compilations \
		&& cargo build --target $(TARGET)
	cp $(SOURCE_DIR)/$(BUILD_DIR)/debug/compilations $@

force:

###############################################################################

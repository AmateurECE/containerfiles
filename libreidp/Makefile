###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/12/2022
#
# LAST EDITED:	    06/25/2022
###

B:=$(shell pwd)/build
$(shell mkdir -p $(B))

VERSION=1.0.0
V=v
TARGET=x86_64-unknown-linux-musl
BUILD_DIR="target/$(TARGET)"
IMAGE_NAME=docker.io/edtwardy/libreidp
GITHUB_URL=https://github.com/AmateurECE/libreidp

all: libreidp-release

###############################################################################
# Common
###

BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/libreidp-entrypoint.sh

$(B)/Containerfile: Containerfile; cp $< $@
$(B)/libreidp-entrypoint.sh: libreidp-entrypoint.sh; cp $< $@

###############################################################################
# Release Build
###

RELEASE_ARTIFACTS := $(BUILD_ARTIFACTS)
RELEASE_ARTIFACTS += $(B)/.containerignore
RELEASE_ARTIFACTS += $(B)/libreidp-release

libreidp-release: $(B)/libreidp-release.lock

$(B)/libreidp-release.lock: SHELL=/bin/bash
$(B)/libreidp-release.lock: $(RELEASE_ARTIFACTS)
	VERSION=$(VERSION); cd $(B) && buildah bud --layers \
		--build-arg LIBREIDP_PATH=./libreidp-release \
		-t "$(IMAGE_NAME):latest" \
		-t "$(IMAGE_NAME):$${VERSION:0:8}"
	touch $@

$(B)/$(V)$(VERSION).tar.gz:
	cd $(B) && curl -L -O "$(GITHUB_URL)/archive/$(V)$(VERSION).tar.gz"

$(B)/libreidp-$(VERSION).lock: $(B)/$(V)$(VERSION).tar.gz
	cd $(B) && tar xzvf $<
	touch $@

$(B)/libreidp-release: $(B)/libreidp-$(VERSION).lock
	cd $(B)/libreidp-$(VERSION) && cargo build --release --target $(TARGET)
	cp $(B)/libreidp-$(VERSION)/$(BUILD_DIR)/release/libreidp $@
	strip $@

$(B)/.containerignore: Makefile
	: # We want to ignore the source artifacts
	echo libreidp-$(VERSION) >> $@
	echo $(V)$(VERSION).tar.gz >> $@

###############################################################################
# Debug Build
###

DEBUG_ARTIFACTS := $(BUILD_ARTIFACTS)
DEBUG_ARTIFACTS += $(B)/libreidp-debug

# Defines SOURCE_DIR: Path to the top of the Git repository
sinclude debug.mk

libreidp-debug: $(B)/libreidp-debug.lock

$(B)/libreidp-debug.lock: SHELL=/bin/bash
$(B)/libreidp-debug.lock: $(DEBUG_ARTIFACTS)
	VERSION=$$(cd $(SOURCE_DIR) && git rev-parse HEAD); \
		cd $(B) && buildah bud --layers \
			--build-arg LIBREIDP_PATH=./libreidp-debug \
			-t "$(IMAGE_NAME):latest" \
			-t "$(IMAGE_NAME):$${VERSION:0:8}"
	: # Copy this image to root storage (/var/lib/containers):
	: # podman save <image_name> | sudo podman load
	touch $@

$(B)/libreidp-debug: force
	cd $(SOURCE_DIR) && cargo build --target $(TARGET)
	cp $(SOURCE_DIR)/$(BUILD_DIR)/debug/libreidp $@

force:

###############################################################################

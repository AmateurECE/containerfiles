###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    09/18/2022
#
# LAST EDITED:	    09/18/2022
###

B:=$(shell pwd)/build
$(shell mkdir -p $(B))

VERSION=b521681de37c7f7f32f50dad4ba9209e83672296
V=
TARGET=x86_64-unknown-linux-musl
BUILD_DIR="target/$(TARGET)"
IMAGE_NAME=docker.io/edtwardy/budget-tool
GITHUB_URL=https://github.com/AmateurECE/budget-tool

all: budget-tool-release

clean:
	rm -rf $(B)

###############################################################################
# Common
###

BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/budget-tool-entrypoint.sh

$(B)/Containerfile: Containerfile; cp $< $@
$(B)/budget-tool-entrypoint.sh: budget-tool-entrypoint.sh; cp $< $@

###############################################################################
# Release Build
###

RELEASE_ARTIFACTS := $(BUILD_ARTIFACTS)
RELEASE_ARTIFACTS += $(B)/.containerignore
RELEASE_ARTIFACTS += $(B)/budget-service-release
RELEASE_ARTIFACTS += $(B)/budget-migrations-release

budget-tool-release: SOURCE_DIR=$(B)/budget-tool-$(VERSION)
budget-tool-release: $(B)/budget-tool-release.lock

$(B)/budget-tool-release.lock: SHELL=/bin/bash
$(B)/budget-tool-release.lock: $(RELEASE_ARTIFACTS)
	VERSION=$(VERSION); cd $(B) && buildah bud --layers \
		--build-arg SERVICE=./budget-service-release \
		--build-arg MIGRATIONS=./budget-migrations-release \
		-t "$(IMAGE_NAME):latest" \
		-t "$(IMAGE_NAME):$${VERSION:0:8}"
	touch $@

$(B)/$(V)$(VERSION).tar.gz:
	cd $(B) && curl -L -O "$(GITHUB_URL)/archive/$(V)$(VERSION).tar.gz"

$(B)/budget-tool-$(VERSION).lock: $(B)/$(V)$(VERSION).tar.gz
	cd $(B) && tar xzvf $<
	touch $@

$(B)/budget-service-release: $(B)/budget-tool-$(VERSION).lock
	cd $(SOURCE_DIR)/budget-service \
		&& cargo build --release --target $(TARGET)
	cp $(SOURCE_DIR)/budget-service/$(BUILD_DIR)/release/budget-service $@
	strip $@

$(B)/budget-migrations-release: MIGRATIONS=$(SOURCE_DIR)/budget-migrations
$(B)/budget-migrations-release: $(B)/budget-tool-$(VERSION).lock
	cd $(MIGRATIONS) && cargo build --release --target $(TARGET)
	cp $(MIGRATIONS)/$(BUILD_DIR)/release/budget-migrations $@
	strip $@

$(B)/.containerignore: Makefile
	: # We want to ignore the source artifacts
	echo budget-tool-$(VERSION) >> $@
	echo $(V)$(VERSION).tar.gz >> $@

###############################################################################
# Debug Build
###

DEBUG_ARTIFACTS := $(BUILD_ARTIFACTS)
DEBUG_ARTIFACTS += $(B)/budget-service-debug
DEBUG_ARTIFACTS += $(B)/budget-migrations-debug

# Defines SOURCE_DIR: Path to the top of the Git repository
sinclude debug.mk

budget-tool-debug: $(B)/budget-tool-debug.lock

$(B)/budget-tool-debug.lock: SHELL=/bin/bash
$(B)/budget-tool-debug.lock: $(DEBUG_ARTIFACTS)
	VERSION=$$(cd $(SOURCE_DIR) && git rev-parse HEAD); \
		cd $(B) && buildah bud --layers \
			--build-arg SERVICE=./budget-service-debug \
			--build-arg MIGRATIONS=./budget-migrations-debug \
			-t "$(IMAGE_NAME):latest" \
			-t "$(IMAGE_NAME):$${VERSION:0:8}"
	: # Copy this image to root storage (/var/lib/containers):
	: # podman save <image_name> | sudo podman load
	touch $@

$(B)/budget-service-debug: force
	cd $(SOURCE_DIR)/budget-service && cargo build --target $(TARGET)
	cp $(SOURCE_DIR)/budget-service/$(BUILD_DIR)/debug/budget-service $@

$(B)/budget-migrations-debug: MIGRATIONS_SOURCE=$(SOURCE_DIR)/budget-migrations
$(B)/budget-migrations-debug: force
	cd $(MIGRATIONS_SOURCE) && cargo build --target $(TARGET)
	cp $(MIGRATIONS_SOURCE)/$(BUILD_DIR)/debug/budget-migrations $@

force:

###############################################################################

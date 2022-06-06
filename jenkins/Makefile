###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/03/2022
#
# LAST EDITED:	    06/06/2022
###

B_ARCH:=$(shell pwd)/build/archlinux-agent
$(shell mkdir -p $(B_ARCH))

VERSION=4f2fca7feea5dd31615f9f170386fe9024d09bb3
BUILD_COMMAND=cargo build
BIN="pkg-builder-$(VERSION)/target/debug/pkg-builder"
IMAGE_NAME=docker.io/edtwardy/archlinux-agent:latest
GITHUB_URL=https://github.com/AmateurECE/pkg-builder

all: archlinux-agent-release

###############################################################################
# archlinux-agent-release
###

BUILD_ARTIFACTS += $(B_ARCH)/Containerfile
BUILD_ARTIFACTS += $(B_ARCH)/jenkins-agent-cmd.sh
BUILD_ARTIFACTS += $(B_ARCH)/pkg-builder

archlinux-agent-release: $(B_ARCH)/archlinux-agent-release.lock

$(B_ARCH)/archlinux-agent-release.lock: $(BUILD_ARTIFACTS)
	cd $(B_ARCH) && buildah bud -t $(IMAGE_NAME) --layers
	touch $@

$(B_ARCH)/Containerfile: Containerfile.archlinux-agent
	mkdir -p $(@D) && cp $< $@
$(B_ARCH)/jenkins-agent-cmd.sh: jenkins-agent-cmd.sh
	mkdir -p $(@D) && cp $< $@

$(B_ARCH)/$(VERSION).tar.gz:
	cd $(B_ARCH) && curl -L -O "$(GITHUB_URL)/archive/$(VERSION).tar.gz"

$(B_ARCH)/pkg-builder-$(VERSION).lock: $(B_ARCH)/$(VERSION).tar.gz
	cd $(B_ARCH) && tar xzvf $<
	touch $@

$(B_ARCH)/pkg-builder: $(B_ARCH)/pkg-builder-$(VERSION).lock
	cd $(B_ARCH)/pkg-builder-$(VERSION) && $(BUILD_COMMAND)
	cp $(B_ARCH)/$(BIN) $@

###############################################################################
# Debug Build
###

archlinux-agent-debug:
	: # TODO

###############################################################################

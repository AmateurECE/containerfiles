###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/03/2022
#
# LAST EDITED:	    01/15/2023
###

B:=$(shell pwd)/build
$(shell mkdir -p $(B))

IMAGE_NAME=docker.io/edtwardy/jenkins-agent
VERSION=1.1.0

all: jenkins-agent-release

clean:
	rm -rf $(B)

###############################################################################
# jenkins-agent-release
###

BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/jenkins-agent-cmd.sh

jenkins-agent-release: $(B)/jenkins-agent-release.lock

$(B)/jenkins-agent-release.lock: $(BUILD_ARTIFACTS)
	cd $(B) && buildah bud --layers \
		-t $(IMAGE_NAME):latest \
		-t $(IMAGE_NAME):$(VERSION)
	touch $@

$(B)/Containerfile: Containerfile
	mkdir -p $(@D) && cp $< $@
$(B)/jenkins-agent-cmd.sh: jenkins-agent-cmd.sh
	mkdir -p $(@D) && cp $< $@

###############################################################################

###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/03/2022
#
# LAST EDITED:	    06/11/2022
###

B:=$(shell pwd)/build
$(shell mkdir -p $(B))

IMAGE_NAME=docker.io/edtwardy/jenkins-agent:latest

all: jenkins-agent-release

###############################################################################
# jenkins-agent-release
###

BUILD_ARTIFACTS += $(B)/Containerfile
BUILD_ARTIFACTS += $(B)/jenkins-agent-cmd.sh

jenkins-agent-release: $(B)/jenkins-agent-release.lock

$(B)/jenkins-agent-release.lock: $(BUILD_ARTIFACTS)
	cd $(B) && buildah bud -t $(IMAGE_NAME) --layers
	touch $@

$(B)/Containerfile: Containerfile
	mkdir -p $(@D) && cp $< $@
$(B)/jenkins-agent-cmd.sh: jenkins-agent-cmd.sh
	mkdir -p $(@D) && cp $< $@

###############################################################################

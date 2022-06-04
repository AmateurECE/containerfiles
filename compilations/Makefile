###############################################################################
# NAME:		    Makefile
#
# AUTHOR:	    Ethan D. Twardy <ethan.twardy@gmail.com>
#
# DESCRIPTION:	    Makefile producing build context, etc.
#
# CREATED:	    06/03/2022
#
# LAST EDITED:	    06/04/2022
###

VERSION=63ecc17a1dc8a130d802d270d73fc0fd5a129558
TARGET=x86_64-unknown-linux-musl
BUILD_COMMAND=cd compilations && cargo build --target $(TARGET)
BIN="compilations-$(VERSION)/compilations/target/$(TARGET)/debug/compilations"
IMAGE_NAME=docker.io/edtwardy/compilations:latest

all: build/compilations

$(VERSION).tar.gz:
	curl -L -O "https://github.com/AmateurECE/compilations/archive/$@"

compilations-$(VERSION).lock: $(VERSION).tar.gz
	tar xzvf $<
	touch $@

build/compilations: compilations-$(VERSION).lock
	cd compilations-$(VERSION) && $(BUILD_COMMAND)
	mkdir -p $(@D)
	cp $(BIN) $@

.containerignore: Makefile
	: # We want to ignore the source artifacts
	echo compilations-$(VERSION) >> $@
	echo $(VERSION).tar.gz >> $@

container: .containerignore build/compilations
	buildah bud -t $(IMAGE_NAME) --layers

clean:
	rm -rf compilations-$(VERSION)
	rm -f $(VERSION).tar.gz
	rm -f compilations-$(VERSION).lock
	rm -rf build
	rm -f .containerignore

###############################################################################

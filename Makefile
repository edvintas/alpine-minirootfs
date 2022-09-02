ALPINE_MMV:=3.16
ALPINE_VERSION:=$(ALPINE_MMV).2
ALPINE_ARCH:=aarch64
PACKAGES:=pkgconf bash make gcc musl-dev linux-headers cmake

all: install rootfs.tar.gz
	@echo all done.

deps:
	apt install bubblewrap -y

install: rootfs
	bwrap --bind $< / --dev /dev --proc /proc /bin/sh -c "apk add $(PACKAGES)"

rootfs: alpine-minirootfs-$(ALPINE_VERSION)-aarch64.tar.gz
	mkdir $@
	cd $@ && tar -xvf ../$<
	cp resolv.conf $@/etc/resolv.conf

rootfs.tar.gz:
	cd rootfs && tar -zcpf ../$@ *

alpine-minirootfs-$(ALPINE_VERSION)-$(ALPINE_ARCH).tar.gz:
	wget --no-check-certificate https://dl-cdn.alpinelinux.org/alpine/v$(ALPINE_MMV)/releases/aarch64/alpine-minirootfs-$(ALPINE_VERSION)-$(ALPINE_ARCH).tar.gz

clean:
	-rm -rf rootfs
	-rm alpine-minirootfs-$(ALPINE_VERSION)-$(ALPINE_ARCH).tar.gz
	-rm rootfs.tar.gz

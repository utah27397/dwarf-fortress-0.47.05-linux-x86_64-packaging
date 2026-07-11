.DEFAULT_GOAL := build

PACKAGE := $(shell awk '$$1 == "Package:" { print $$2; exit }' DEBIAN/control)
VERSION := $(shell awk '$$1 == "Version:" { print $$2; exit }' DEBIAN/control)
ARCH := $(shell awk '$$1 == "Architecture:" { print $$2; exit }' DEBIAN/control)
OUTPUT ?= ../$(PACKAGE)_$(VERSION)_$(ARCH).deb
DF_ARCHIVE_DIR ?= upstream/dwarf-fortress-linux
DF_ARCHIVE_COMMIT := 19c0b532af2df8532cc6cbb6c7b558925d48c756
DF_INSTALL_DIR ?= opt/dwarf-fortress-0.47.05
DF_MUTABLE_TOPLEVEL ?= data raw

.PHONY: build check-source source-info

check-source:
	@set -eu; \
	for required in \
		DEBIAN/control \
		DEBIAN/prerm \
		$(DF_ARCHIVE_DIR)/df \
		$(DF_ARCHIVE_DIR)/libs/Dwarf_Fortress \
		usr/bin/dwarffortress \
		usr/lib/$(PACKAGE)/clean-user-defaults; \
	do \
		if [ ! -e "$$required" ]; then \
			echo "missing package file: $$required" >&2; \
			exit 1; \
		fi; \
	done; \
	actual=$$(git -C "$(DF_ARCHIVE_DIR)" rev-parse HEAD); \
	if [ "$$actual" != "$(DF_ARCHIVE_COMMIT)" ]; then \
		echo "unexpected Dwarf Fortress archive commit: $$actual" >&2; \
		echo "expected $(DF_ARCHIVE_COMMIT)" >&2; \
		exit 2; \
	fi

source-info: check-source
	@echo "source path:      $(DF_ARCHIVE_DIR)"
	@echo "source commit:    $(DF_ARCHIVE_COMMIT)"
	@echo "install path:     $(DF_INSTALL_DIR)"

build: check-source
	@set -eu; \
	tmp=$$(mktemp -d "$${TMPDIR:-/tmp}/$(PACKAGE)-build.XXXXXX"); \
	trap 'rm -rf "$$tmp"' EXIT HUP INT TERM; \
	mkdir -p "$$tmp/pkg"; \
	cp -a DEBIAN "$$tmp/pkg/"; \
	mkdir -p "$$tmp/pkg/$(DF_INSTALL_DIR)"; \
	git -C "$(DF_ARCHIVE_DIR)" archive --format=tar HEAD | tar -C "$$tmp/pkg/$(DF_INSTALL_DIR)" -xf -; \
	cp -a usr "$$tmp/pkg/"; \
	mkdir -p "$$tmp/pkg/usr/share/$(PACKAGE)"; \
	manifest_dir="$$tmp/pkg/usr/share/$(PACKAGE)"; \
	: > "$$manifest_dir/default-user-files"; \
	: > "$$manifest_dir/default-user-dirs"; \
	for top in $(DF_MUTABLE_TOPLEVEL); do \
		[ -d "$$tmp/pkg/$(DF_INSTALL_DIR)/$$top" ] || continue; \
		(cd "$$tmp/pkg/$(DF_INSTALL_DIR)" && find "$$top" -type f | sort) >> "$$manifest_dir/default-user-files"; \
		(cd "$$tmp/pkg/$(DF_INSTALL_DIR)" && find "$$top" -type d | sort) >> "$$manifest_dir/default-user-dirs"; \
	done; \
	sort -u -o "$$manifest_dir/default-user-files" "$$manifest_dir/default-user-files"; \
	sort -u -o "$$manifest_dir/default-user-dirs" "$$manifest_dir/default-user-dirs"; \
	chmod 755 "$$tmp/pkg/DEBIAN/prerm"; \
	chmod 755 "$$tmp/pkg/$(DF_INSTALL_DIR)/df"; \
	chmod 755 "$$tmp/pkg/$(DF_INSTALL_DIR)/libs/Dwarf_Fortress"; \
	chmod 755 "$$tmp/pkg/usr/bin/dwarffortress"; \
	chmod 755 "$$tmp/pkg/usr/lib/$(PACKAGE)/clean-user-defaults"; \
	dpkg-deb --root-owner-group --build "$$tmp/pkg" "$(OUTPUT)"

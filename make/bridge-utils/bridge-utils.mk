PACKAGE_LC:=bridge-utils
PACKAGE_UC:=BRIDGE_UTILS
$(PACKAGE_UC)_VERSION:=1.2
$(PACKAGE_INIT_BIN)
BRIDGE_UTILS_SOURCE:=bridge-utils-$(BRIDGE_UTILS_VERSION).tar.gz
BRIDGE_UTILS_SITE:=http://mesh.dl.sourceforge.net/sourceforge/bridge
BRIDGE_UTILS_MAKE_DIR:=$(MAKE_DIR)/bridge-utils
BRIDGE_UTILS_DIR:=$(SOURCE_DIR)/bridge-utils-$(BRIDGE_UTILS_VERSION)
BRIDGE_UTILS_BINARY:=$(BRIDGE_UTILS_DIR)/brctl/brctl
BRIDGE_UTILS_TARGET_DIR:=$(PACKAGES_DIR)/bridge-utils-$(BRIDGE_UTILS_VERSION)
BRIDGE_UTILS_TARGET_BINARY:=$(BRIDGE_UTILS_TARGET_DIR)/root/sbin/brctl
BRIDGE_UTILS_STARTLEVEL=90 # for PACKAGE_LIST, no autostart

$(PACKAGE_UC)_CONFIGURE_PRE_CMDS:=
$(PACKAGE_UC)_CONFIGURE_PRE_CMDS += aclocal --force ;
$(PACKAGE_UC)_CONFIGURE_PRE_CMDS += libtoolize --force ;
$(PACKAGE_UC)_CONFIGURE_PRE_CMDS += autoconf --force ;
$(PACKAGE_UC)_CONFIGURE_PRE_CMDS += autoheader --force ;

$(PACKAGE_UC)_CONFIGURE_OPTIONS:=
$(PACKAGE_UC)_CONFIGURE_OPTIONS += --with-randomdev=/dev/random
$(PACKAGE_UC)_CONFIGURE_OPTIONS += --with-linux-headers=$(KERNEL_DIR)/linux/include


$(PACKAGE_SOURCE_DOWNLOAD)
$(PACKAGE_UNPACKED)
$(PACKAGE_CONFIGURED_CONFIGURE)

$(BRIDGE_UTILS_BINARY): $(BRIDGE_UTILS_DIR)/.configured
	PATH="$(TARGET_PATH)" $(MAKE) -C $(BRIDGE_UTILS_DIR)

$(BRIDGE_UTILS_TARGET_BINARY): $(BRIDGE_UTILS_BINARY)
	mkdir -p $(dir $@)
	$(INSTALL_BINARY_STRIP)

bridge-utils: uclibc $(BRIDGE_UTILS_TARGET_BINARY)

bridge-utils-precompiled: bridge-utils $(BRIDGE_UTILS_TARGET_BINARY)

bridge-utils-clean:
	-$(MAKE) -C $(BRIDGE_UTILS_DIR) clean

bridge-utils-dirclean:
	$(RM) -r $(BRIDGE_UTILS_DIR)
	$(RM) -r $(PACKAGES_DIR)/bridge-utils-$(BRIDGE_UTILS_VERSION)
	$(RM) $(PACKAGES_DIR)/.bridge-utils-$(BRIDGE_UTILS_VERSION)

bridge-utils-uninstall:
	$(RM) $(BRIDGE_UTILS_TARGET_BINARY)


$(PACKAGE_FINI)

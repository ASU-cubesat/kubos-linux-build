###############################################
#
# Kubos File Transfer Service
#
###############################################

KUBOS_CORE_FILE_TRANSFER_POST_BUILD_HOOKS += FILE_TRANSFER_BUILD_CMDS
KUBOS_CORE_FILE_TRANSFER_POST_INSTALL_TARGET_HOOKS += FILE_TRANSFER_INSTALL_TARGET_CMDS
KUBOS_CORE_FILE_TRANSFER_POST_INSTALL_TARGET_HOOKS += FILE_TRANSFER_INSTALL_INIT_SYSV

define FILE_TRANSFER_BUILD_CMDS
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/file-service && \
    PATH=$(PATH):~/.cargo/bin && \
	CC=$(TARGET_CC) cargo build --target $(CARGO_TARGET) --release
endef

# Install the application into the rootfs file system
define FILE_TRANSFER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/$(CARGO_OUTPUT_DIR)/file-service \
		$(TARGET_DIR)/usr/sbin
endef

# Install the init script
define FILE_TRANSFER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_KUBOS_LINUX_PATH)/package/kubos/kubos-core/kubos-core-file-transfer/kubos-core-file-transfer \
	    $(TARGET_DIR)/etc/init.d/S$(BR2_KUBOS_CORE_FILE_TRANSFER_INIT_LVL)kubos-core-file-transfer
endef

kubos-core-file-transfer-cargoclean: kubos-core-file-transfer-dirclean
	cd $(BUILD_DIR)/kubos-$(KUBOS_VERSION)/services/file-service && \
	PATH=$(PATH):~/.cargo/bin && \
	cargo clean

$(eval $(virtual-package))
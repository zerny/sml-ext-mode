.PHONY: package clean

PKG_VERSION=0.1
PKG_NAME=sml-ext-mode
PKG_DSC=$(PKG_NAME)-pkg.el
PKG_DIR=$(PKG_NAME)-$(PKG_VERSION)
PKG_TAR=$(PKG_DIR).tar

PKG_FILES=$(PKG_DSC) $(PKG_NAME).el

package: $(PKG_NAME)-$(PKG_VERSION).tar

clean:
	rm -rf $(PKG_DIR) $(PKG_TAR)

$(PKG_TAR): $(PKG_FILES)
	rm -rf $(PKG_DIR)
	mkdir -p $(PKG_DIR)
	cp README.md $(PKG_DIR)/README
	cp $(PKG_FILES) $(PKG_DIR)
	sed "s/__VERSION__/$(PKG_VERSION)/g" $(PKG_DSC) > $(PKG_DIR)/$(PKG_DSC)
	tar cf $(PKG_TAR) $(PKG_DIR)

.PHONY: package clean

PKG_VERSION=0.1
PKG_NS=sml-ext
PKG_NAME=$(PKG_NS)-mode
PKG_DSC=$(PKG_NAME)-pkg.el
PKG_DIR=$(PKG_NAME)-$(PKG_VERSION)
PKG_TAR=$(PKG_DIR).tar

PKG_FILES=\
  README \
  $(PKG_DSC) \
  $(PKG_NAME).el \
  $(PKG_NS)-process.el \
  $(PKG_NS)-process-mlton.el

package: $(PKG_NAME)-$(PKG_VERSION).tar

clean:
	rm -rf $(PKG_DIR) $(PKG_TAR)

$(PKG_DIR):
	mkdir -p $(PKG_DIR)

$(PKG_DIR)/README: README.md
	cp $< $@

$(PKG_DIR)/$(PKG_DSC): $(PKG_DSC)
	sed "s/__VERSION__/$(PKG_VERSION)/g" $< > $@

$(PKG_DIR)/%: %
	cp $< $@

$(PKG_TAR): $(PKG_DIR) $(PKG_FILES:%=$(PKG_DIR)/%)
	tar cf $(PKG_TAR) $(PKG_DIR)

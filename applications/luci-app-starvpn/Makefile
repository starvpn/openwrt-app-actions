

include $(TOPDIR)/rules.mk

PKG_VERSION:=0.0.1-20240521
PKG_RELEASE:=

LUCI_TITLE:=LuCI support for 星空组网
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+starvpn

define Package/luci-app-starvpn/conffiles
/etc/config/starvpn
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

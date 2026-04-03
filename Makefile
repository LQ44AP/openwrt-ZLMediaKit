include $(TOPDIR)/rules.mk

PKG_NAME:=zlmediakit
PKG_VERSION:=master
PKG_RELEASE:=1

# 指定源码来源
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ZLMediaKit/ZLMediaKit.git
PKG_SOURCE_VERSION:=master
PKG_SOURCE_SUBMODULES:=1  # 关键：自动克隆所有子模块

PKG_MAINTAINER:=Gemini_Assistant
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/zlmediakit
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ZLMediaKit
  URL:=https://github.com/ZLMediaKit/ZLMediaKit
  DEPENDS:=+libstdcpp +libopenssl +zlib +libsrtp2 +libuv
endef

CMAKE_OPTIONS += \
	-DENABLE_WEBRTC=ON \
	-DENABLE_HLS=ON \
	-DENABLE_ASAN=OFF \
	-DENABLE_TESTS=OFF \
	-DENABLE_SERVER=ON \
	-DCMAKE_BUILD_TYPE=Release

define Package/zlmediakit/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/zlmediakit
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/release/linux/Release/MediaServer $(1)/usr/bin/ZLMediaServer
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/config.ini $(1)/etc/zlmediakit/config.ini
endef

$(eval $(call BuildPackage,zlmediakit))

include $(TOPDIR)/rules.mk

PKG_NAME:=zlmediakit
PKG_VERSION:=2026-04-03
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ZLMediaKit/ZLMediaKit.git
PKG_SOURCE_VERSION:=master
PKG_MIRROR_HASH:=skip

PKG_MAINTAINER:=Gemini
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/zlmediakit
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Lightweight RTSP/RTMP/HTTP/HLS/HTTP-FLV/WebSocket-FLV server
  DEPENDS:=+libstdcpp +libopenssl +zlib +libpthread
endef

define Package/zlmediakit/description
  A high-performance streaming media server. 
  Configured for forwarding only to save resources on OpenWrt.
endef

# 核心：通过 CMAKE_OPTIONS 禁用非必要模块
CMAKE_OPTIONS += \
    -DENABLE_HLS=ON \
    -DENABLE_OPENSSL=ON \
    -DENABLE_FFMPEG=OFF \
    -DENABLE_REPL=OFF \
    -DENABLE_CXX11=ON \
    -DENABLE_MYSQL=OFF \
    -DENABLE_FAAC=OFF \
    -DENABLE_X264=OFF \
    -DENABLE_OPUS=OFF \
    -DENABLE_MP4=OFF \
    -DENABLE_RTPPROXY=ON \
    -DENABLE_AV1=OFF \
    -DENABLE_WEBRTC=OFF \
    -DENABLE_SRT=OFF \
    -DENABLE_MEM_CHECK=OFF \
    -DCMAKE_CXX_FLAGS="-DENABLE_AV1=0"

define Build/Prepare
	$(call Build/Prepare/Default)
	# 物理移除 AV1 相关代码，防止 ext-codec 模块扫描到它
	rm -f $(PKG_BUILD_DIR)/ext-codec/AV1.h
	rm -f $(PKG_BUILD_DIR)/ext-codec/AV1.cpp
	# 创建一个空的 AV1.h 防止其他文件 include 时直接报错（可选）
	touch $(PKG_BUILD_DIR)/ext-codec/AV1.h
endef

define Package/zlmediakit/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/release/linux/$(PKG_NAME)/MediaServer $(1)/usr/bin/zlmediakit
	
	$(INSTALL_DIR) $(1)/etc/zlmediakit
	$(CP) $(PKG_BUILD_DIR)/conf/config.ini $(1)/etc/zlmediakit/
endef

$(eval $(call BuildPackage,zlmediakit))

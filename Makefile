include $(TOPDIR)/rules.mk

PKG_NAME:=zlmediakit
PKG_VERSION:=20260403
PKG_RELEASE:=1

# 指定源码来源
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ZLMediaKit/ZLMediaKit.git
PKG_SOURCE_VERSION:=master
PKG_SOURCE_SUBMODULES:=1

PKG_MAINTAINER:=Gemini_Assistant

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/zlmediakit
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ZLMediaKit (Stream Proxy Only)
  URL:=https://github.com/ZLMediaKit/ZLMediaKit
  # 移除不需要的 libatomic (如果不涉及复杂转码，基础库通常够用)
  # 但保留 libstdcpp 和 openssl，这是转发流（如 RTSPS/RTMP Over TLS）必须的
  DEPENDS:=+libstdcpp +libopenssl +zlib
endef

# 针对“只转发”场景的编译选项
CMAKE_OPTIONS += \
	-DENABLE_WEBRTC=OFF \
	-DENABLE_HLS=OFF \
	-DENABLE_ASAN=OFF \
	-DENABLE_FFMPEG=OFF \
	-DENABLE_TESTS=OFF \
	-DENABLE_SERVER=ON \
	-DENABLE_RTSP=ON \
	-DENABLE_RTMP=ON \
	-DENABLE_HTTP_TS=ON \
	-DENABLE_MEM_DEBUG=OFF \
	-DENABLE_OPENSSL=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DENABLE_BACKTRACE=OFF \
	-DCMAKE_CXX_FLAGS="-DENABLE_BACKTRACE=OFF"

define Package/zlmediakit/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/zlmediakit
	
	# 只安装核心二进制文件
	# 注意：如果 GitHub Actions 报错找不到路径，请根据日志将下行改为：
	# $(INSTALL_BIN) $(PKG_BUILD_DIR)/build/MediaServer $(1)/usr/bin/ZLMediaServer
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/release/linux/Release/MediaServer $(1)/usr/bin/ZLMediaServer
	
	# 只安装基础配置文件
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/config.ini $(1)/etc/zlmediakit/config.ini
endef

$(eval $(call BuildPackage,zlmediakit))

include $(TOPDIR)/rules.mk

# 软件包信息
PKG_NAME:=zlmediakit
PKG_VERSION:=master
PKG_RELEASE:=1

# 源代码路径：由于你在 Actions 中已经 Checkout 到了本地，这里指向本地 src 目录
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# 定义包属性
define Package/zlmediakit
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ZLMediaKit High-performance RTSP/RTMP/HTTP/HLS/WebSocket media server
  URL:=https://github.com/ZLMediaKit/ZLMediaKit
  DEPENDS:=+libstdcpp +libopenssl +zlib +libsrtp2 +libuv
endef

define Package/zlmediakit/description
  A lightweight and high-performance cross-platform streaming media server.
endef

# CMake 编译选项
# 我们在这里关闭一些在路由器上不常用的功能以减小体积
CMAKE_OPTIONS += \
	-DENABLE_WEBRTC=ON \
	-DENABLE_HLS=ON \
	-DENABLE_ASAN=OFF \
	-DENABLE_TESTS=OFF \
	-DENABLE_EXECUTABLE=ON \
	-DENABLE_SERVER=ON \
	-DCMAKE_BUILD_TYPE=Release

# 准备源代码：将 Actions 已经下载好的源码同步到编译目录
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

# 安装指令：定义编译后的文件安装到哪里
define Package/zlmediakit/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/zlmediakit
	
	# 安装主程序
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/release/linux/Release/MediaServer $(1)/usr/bin/ZLMediaServer
	
	# 安装配置文件
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/conf/config.ini $(1)/etc/zlmediakit/config.ini
endef

$(eval $(call BuildPackage,zlmediakit))

# 1. 包含基础规则和变量
include $(TOPDIR)/rules.mk

# 2. 定义包的基本信息
PKG_NAME:=zlmediakit
PKG_VERSION:=c3c0fb4448f7a7f754113fabf8c28ced04171606
PKG_RELEASE:=1

# 3. 定义源码获取方式 (这里以从Git仓库克隆为例)
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ZLMediaKit/ZLMediaKit.git
PKG_SOURCE_VERSION:=master # 确保与 PKG_VERSION 一致或指定具体commit hash
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz

# 4. 关键点：定义构建目录和依赖的库
PKG_BUILD_DEPENDS:=libopenssl
PKG_INSTALL:=1

# 5. 包含OpenWrt的包定义和CMake构建规则
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# 6. 定义包在menuconfig中的信息
define Package/$(PKG_NAME)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=ZLMediaKit (High-performance stream media server)
  URL:=https://github.com/ZLMediaKit/ZLMediaKit
  DEPENDS:=+libopenssl +libstdcpp +libpthread
endef

# 7. 包的描述信息
define Package/$(PKG_NAME)/description
ZLMediaKit is a high-performance stream media server framework.
This version is built without FFmpeg for pure forwarding only.
endef

# 8. 关键的编译配置：为CMake传递参数，以禁用FFmpeg
TARGET_CXXFLAGS += -std=c++11
CMAKE_OPTIONS += \
	-DENABLE_FFMPEG=OFF \

# 9. 定义如何将编译好的文件安装到OpenWrt固件中
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/release/$(CONFIG_ARCH)/Debug/MediaServer $(1)/usr/bin/zlmediakit
	$(INSTALL_DIR) $(1)/etc/zlmediakit
	$(INSTALL_CONF) ./files/config.ini $(1)/etc/zlmediakit/
endef

# 10. 最后，调用构建宏
$(eval $(call BuildPackage,$(PKG_NAME)))

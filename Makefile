export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

TWEAK_NAME = Amēlija

Amēlija_FILES = Amēlija.x
Amēlija_CFLAGS = -fobjc-arc
Amēlija_LIBRARIES = gcuniversal

SUBPROJECTS += AmēlijaPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"

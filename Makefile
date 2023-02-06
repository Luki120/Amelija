export TARGET := iphone:clang:latest:latest

INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Amēlija

Amēlija_FILES = Amēlija.x
Amēlija_CFLAGS = -fobjc-arc
Amēlija_LIBRARIES = gcuniversal

SUBPROJECTS = AmēlijaPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

DEBUG = O
#FINALPACKAGE = 1

THEOS_DEVICE_IP = 192.168.0.8

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Amēlija

Amēlija_FILES = Amēlija.x
Amēlija_CFLAGS = -fobjc-arc
Amēlija_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += AmēlijaPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"
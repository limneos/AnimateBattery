include theos/makefiles/common.mk

TWEAK_NAME = AnimateBattery
AnimateBattery_FILES = Tweak.xm
AnimateBattery_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk

#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/realme/even/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_even
PRODUCT_DEVICE := even
PRODUCT_MANUFACTURER := realme
PRODUCT_BRAND := realme
PRODUCT_MODEL := RMX3191

# Misc
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_BOOT_ANIMATION_RES := 720

PRODUCT_GMS_CLIENTID_BASE := android-realme

# Build info
PRODUCT_BUILD_PROP_OVERRIDES += \
BuildDesc="sys_mssi_64_cn_armv82-user 13 TP1A.220905.001 1716367279348 release-keys" \
BuildFingerprint=realme/RMX3191/RMX3191:13/TP1A.220905.001/1716367279348:user/release-keys \
DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
DeviceProduct=$(PRODUCT_SYSTEM_NAME)

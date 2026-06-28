#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
DEVICE_PATH := device/realme/even

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Dalvik VM Configuration
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# IMS-Vendor
$(call inherit-product-if-exists, vendor/mediatek/ims/ims.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 30

# Axion Stuff
PRODUCT_NO_CAMERA := false
AXION_CAMERA_REAR_INFO := 50,2,2
AXION_CAMERA_FRONT_INFO := 8
AXION_MAINTAINER := DumbDragon
AXION_PROCESSOR := MTK_Helio_G85

# Axion Optional Flags
TARGET_NEEDS_DOZE_FIX := true
TARGET_INCLUDE_AXFX := true
TARGET_ENABLE_BLUR := true
PERF_ANIM_OVERRIDE := true
TARGET_USES_SLMK := true
TARGET_INCLUDES_LOS_PREBUILTS := false
HBM_SUPPORTED := true
HBM_NODE := /sys/kernel/oplus_display/hbm
BYPASS_CHARGE_SUPPORTED := true
BYPASS_CHARGE_TOGGLE_PATH ?= /sys/class/oplus_chg/battery/mmi_charging_enable
TARGET_IS_LOW_RAM = true
TARGET_DISABLES_LIBPERF := true

# AxBurstengine
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/axion/ax_perf_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/ax_perf_config.xml

# Display
TARGET_SCREEN_DENSITY := 320

# VINTF
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service

PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    android.hardware.bluetooth.audio-impl

PRODUCT_PACKAGES += \
    MtkInCallService

PRODUCT_PACKAGES += \
    libaudiofoundation.vendor \
    libbluetooth_audio_session \
    libunwindstack.vendor \
    libalsautils.vendor \
    libtinyalsa.vendor \
    libnbaio_mono \
    libtinycompress \
    libdynproc \
    libhapticgenerator

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml


# Biometrics
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.3-service.oplus

TARGET_EXCLUDES_AUDIOFX := true

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1.vendor

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.common@1.0.vendor \
    android.hardware.camera.device@3.6.vendor \
    android.hardware.camera.provider@2.6.vendor \
    libcamera2ndk_vendor \
    libexpat.vendor \
    libexif.vendor \
    libpng.vendor

PRODUCT_PACKAGES += \
    libcamera_metadata.vendor \
    libcamera_metadata_shim

# Cgroup
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups_30.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
    $(DEVICE_PATH)/configs/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.composer@2.2.vendor \
    android.hardware.graphics.composer@2.3.vendor \
    android.hardware.memtrack-service.mediatek

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@4.0.vendor \
    libvulkan \
    libdrm.vendor \
    libpower.vendor 

PRODUCT_PACKAGES += \
    libutilscallstack.vendor

# Doze
PRODUCT_PACKAGES += \
    OplusDoze

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

PRODUCT_PACKAGES += \
    android.hardware.drm@1.4.vendor \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Engineering mode
PRODUCT_PACKAGES += \
    libjni_shim

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-com.mediatek.engineermode.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-com.mediatek.engineermode.xml

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.gatekeeper@1.0-impl

PRODUCT_PACKAGES += \
    libgatekeeper.vendor

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss.measurement_corrections@1.0.vendor \
    android.hardware.gnss.measurement_corrections@1.1.vendor \
    android.hardware.gnss.visibility_control@1.0.vendor \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor \
    android.hardware.gnss-V1-ndk.vendor \
    libcurl.vendor

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport \
    libhidltransport.vendor \
    libhardware \
    libhardware.vendor \
    libhwbinder \
    libhwbinder.vendor \
    libhidlmemory.vendor

# Init
$(call soong_config_set,libinit,vendor_init_lib,//$(LOCAL_PATH):libinit_even)

# Inherit several Android Go Configurations (Beneficial for everyone, even on non-Go devices)
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/boot/boot-image-profile.txt

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0.vendor \
    android.hardware.keymaster@4.0.vendor \
    android.hardware.keymaster@4.1.vendor \
   libkeymaster4.vendor:64 \
   libkeymaster4support.vendor:64 \
   libkeymaster4_1support.vendor:64 \
   libkeymaster41.vendor:64 \
   libkeymaster_messages.vendor:64 \
   libkeymaster_portable.vendor:64 \
   libpuresoftkeymasterdevice.vendor:64 \
   libsoft_attestation_cert.vendor:64 \
   libkeystore-wifi-hidl \
   libkeystore-engine-wifi-hidl \
   libnetutils.vendor

$(call inherit-product, hardware/oplus/oplus-fwk/oplus-fwk.mk)

# Oplus
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.osense.client-V1-ndk_platform \
    vendor.oplus.hardware.performance-V1-ndk_platform

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.even

# Vendor Log Tag
include $(DEVICE_PATH)/configs/props/vendor_logtag.mk

# Media
PRODUCT_PACKAGES += \
    libcodec2_hidl@1.1.vendor \
    libcodec2_hidl@1.2.vendor \
    libavservices_minijail_vendor \
    libstagefright_softomx_plugin.vendor \
    libsfplugin_ccodec_utils.vendor \
    libcodec2_soft_common.vendor

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/seccomp,$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/media,$(TARGET_COPY_OUT_VENDOR)/etc)


# Neural Networks
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.0.vendor \
    android.hardware.neuralnetworks@1.1.vendor \
    android.hardware.neuralnetworks@1.2.vendor \
    android.hardware.neuralnetworks@1.3.vendor \
    libtextclassifier_hash.vendor


# Update
AB_OTA_UPDATER := false
PRODUCT_SOONG_NAMESPACES += bootable/deprecated-ota

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_PACKAGES += \
    FrameworksResOverlayEven \
    SettingsOverlayEven \
    SettingsProviderResOverlayEven \
    SystemUIOverlayEven \
    TelephonyOverlayEven \
    WifiResOverlayEven \
    TetheringResOverlayEven \
    CarrierConfigOverlayEven \
    LauncherOverlayEven \
    OplusDozeOverlayEven

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# PowerOffAlarm
PRODUCT_PACKAGES += \
    PowerOffAlarm

# Lineage-Specific overlays
PRODUCT_PACKAGES += \
    LineageApertureOverlayEven \
    PowerOffAlarmOverlayEven \
    LineageDialerOverlayEven \
    LineageSDKOverlayEven

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr

PRODUCT_PACKAGES += \
    libmtkperf_client_vendor \
    libmtkperf_client

PRODUCT_PACKAGES += \
    vendor.mediatek.hardware.mtkpower@1.2-service.stub \
    vendor.mediatek.hardware.mtkpower@1.0.vendor \
    vendor.mediatek.hardware.mtkpower@1.1.vendor

PRODUCT_PACKAGES += \
    android.hardware.power@1.3.vendor

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/power/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Public libraries
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Radio
PRODUCT_PACKAGES += \
    android.hardware.radio.config@1.3.vendor \
    android.hardware.radio@1.6.vendor

# RCS 
PRODUCT_PACKAGES += \
    com.android.ims.rcsmanager \
    RcsService \
    PresencePolling

# Rootdir
PRODUCT_PACKAGES += \
    fstab.mt6768 \
    fstab.mt6768.ramdisk \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6768.rc \
    init.mt6768.power.rc \
    init.mt6768.usb.rc \
    init.project.rc \
    init.sensor_1_0.rc \
    init.target.rc \
    ueventd.mtk.rc \
    ueventd.oplus.rc

# Fastboot
PRODUCT_PACKAGES += \
    init.recovery.mt6768.rc

# Secure Element
PRODUCT_PACKAGES += \
    android.hardware.secure_element@1.2.vendor

# Sensors
PRODUCT_PACKAGES += \
    libshim_sensors \
    libsensorndkbridge \
    android.hardware.sensors@2.0-ScopedWakelock.vendor \
    android.hardware.sensors@1.0.vendor \
    android.hardware.sensors@2.1.vendor \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.sensors@1.0-convert-shared.vendor \

PRODUCT_PACKAGES += \
    sensors.dynamic_sensor_hal:64

PRODUCT_PACKAGES += \
    libdumpstateutil.vendor:64

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Soundtrigger
PRODUCT_PACKAGES += \
    android.hardware.soundtrigger@2.3-impl

# Soong namespaces
 PRODUCT_SOONG_NAMESPACES += \
     hardware/mediatek \
     hardware/oplus \
     hardware/lineage/compat \
     hardware/google/interfaces \
    hardware/google/pixel \
    hardware/mediatek/libmtkperf_client \
    hardware/mediatek/aidl/vibrator \
    hardware/lineage/interfaces/power-libperfmgr \
    $(DEVICE_PATH)

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0.vendor \
    android.hardware.thermal@1.0-impl

# Touch
PRODUCT_PACKAGES += \
    vendor.lineage.touch-service.oplus

$(call soong_config_set,OPLUS_LINEAGE_TOUCH_HAL,INCLUDE_DIR,$(LOCAL_PATH)/touch/include)

# Use device-specific init.mt6768.usb.rc instead of hardware/mediatek generic
$(call soong_config_set,mediatek_gadget,use_custom_usb_gadget_rc,true)

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3.vendor \
    android.hardware.usb.gadget@1.1.vendor

# Vibrator
TARGET_VIBRATOR_SUPPORTS_EFFECTS := true
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.mediatek

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager

# VNDK
PRODUCT_PACKAGES += \
    libbinder-v32 \
    libhidlbase-v32  \
    libutils-v32 \
    libstagefright_foundation-v33.vendor

PRODUCT_PACKAGES += \
    libshim_ui\
    libbase_shim \
    libprocessgroup_shim

# Wi-Fi
PRODUCT_PACKAGES += \
    android.hardware.tetheroffload.config@1.0.vendor \
    android.hardware.tetheroffload.control@1.0.vendor \
    android.hardware.tetheroffload.control@1.1.vendor \
    android.hardware.wifi-service \
    wpa_supplicant \
    hostapd \
    libwifi-hal-wrapper

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(DEVICE_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(DEVICE_PATH)/configs/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf

# Inherit the proprietary files
$(call inherit-product, vendor/realme/even/even-vendor.mk)

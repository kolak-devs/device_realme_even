echo start cloning repos
VT=vendor/realme/even/even-vendor.mk
if ! [ -a $VT ]; then git clone -b sixteen/dev https://github.com/kolak-devs/vendor_realme_even_rui4.git --depth=1 vendor/realme/even
fi
KT=kernel/realme/even/KernelSU/kernel/Kconfig
if ! [ -a $KT ]; then rm -rf kernel/realme/even && git clone --recurse-submodules https://github.com/kolak-devs/zenium_realme_even --depth=1 kernel/realme/even
fi
MTK_SEPOLICY=device/mediatek/sepolicy_vndr/SEPolicy.mk
if ! [ -a $MTK_SEPOLICY ]; then git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr device/mediatek/sepolicy_vndr
fi
MTK=hardware/mediatek/Android.bp
if ! [ -a $MTK ]; then rm -rf hardware/mediatek && git clone https://github.com/LineageOS/android_hardware_mediatek hardware/mediatek
fi
OPLUS=hardware/oplus/Android.bp
if ! [ -a $OPLUS ]; then rm -rf hardware/oplus && git clone https://github.com/kolak-devs/android_hardware_oplus hardware/oplus
fi
VT-IMS=vendor/mediatek/ims/ims.mk
if ! [ -a $VT-IMS ]; then rm -rf vendor/mediatek/ims && git clone https://github.com/techyminati/android_vendor_mediatek_ims.git vendor/mediatek/ims
fi
POCKET=packages/apps/PocketMode/pocket_mode.mk
if ! [ -a $POCKET ]; then git clone https://github.com/nishant6342/packages_apps_PocketMode packages/apps/PocketMode
fi
DOLBY=hardware/dolby/dolby.mk
if ! [ -a $DOLBY ]; then git clone -b A16 https://github.com/FlamingoOS-Devices/hardware_dolby.git  hardware/dolby
fi

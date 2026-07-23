/*
 * Copyright (C) 2020 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdlib>
#include <fstream>
#include <cstring>
#include <sys/sysinfo.h>

#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "vendor_init.h"
#include "property_service.h"

using android::base::GetProperty;

std::vector<std::string> ro_props_default_source_order = {
    "",
    "odm.",
    "system.",
    "product.",
    "system_ext.",
    "vendor.",
    "vendor_dlkm.",
};

void property_override(char const prop[], char const value[])
{
    auto pi = (prop_info *) __system_property_find(prop);

    if (pi != nullptr) {
        __system_property_update(pi, value, strlen(value));
    } else {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void load_dalvik_properties() {
    char const *heapstartsize;
    char const *heapgrowthlimit;
    char const *heapsize;
    char const *heapminfree;
    char const *heapmaxfree;
    char const *heaptargetutilization;
    struct sysinfo sys;

    sysinfo(&sys);

    if (sys.totalram >= 5ull * 1024 * 1024 * 1024) {
        // from - phone-xhdpi-6144-dalvik-heap.mk
        heapstartsize = "16m";
        heapgrowthlimit = "256m";
        heapsize = "512m";
        heaptargetutilization = "0.5";
        heapminfree = "8m";
        heapmaxfree = "32m";
    } else if (sys.totalram >= 3ull * 1024 * 1024 * 1024) {
        // from - phone-xhdpi-4096-dalvik-heap.mk
        heapstartsize = "8m";
        heapgrowthlimit = "192m";
        heapsize = "512m";
        heaptargetutilization = "0.6";
        heapminfree = "8m";
        heapmaxfree = "16m";
    } else {
        return;
    }

    property_override("dalvik.vm.heapstartsize", heapstartsize);
    property_override("dalvik.vm.heapgrowthlimit", heapgrowthlimit);
    property_override("dalvik.vm.heapsize", heapsize);
    property_override("dalvik.vm.heaptargetutilization", heaptargetutilization);
    property_override("dalvik.vm.heapminfree", heapminfree);
    property_override("dalvik.vm.heapmaxfree", heapmaxfree);
}
void set_device_props(const std::string model, const std::string marketname) {
    const auto set_ro_product_prop = [](const std::string &source,
                                        const std::string &prop,
                                        const std::string &value) {
        auto prop_name = "ro.product." + source + prop;
        property_override(prop_name.c_str(), value.c_str());
    };

    for (const auto &source : ro_props_default_source_order) {
        set_ro_product_prop(source, "device", model);
        set_ro_product_prop(source, "model", model);
        set_ro_product_prop(source, "name", model);
        set_ro_product_prop(source, "marketname", marketname);
    }
}

void vendor_load_properties() {
    std::string prjname = GetProperty("ro.boot.prjname", "");

    if (prjname == "20761") {
        set_device_props("RMX3191", "Realme C25");
        property_override("ro.build.fingerprint",
                          "realme/RMX3191/RMX3191:13/TP1A.220905.001/1716367279348:user/release-keys");
    } else if (prjname == "20762") {
        set_device_props("RMX3193", "Realme C25");
        property_override("ro.build.fingerprint",
                          "realme/RMX3193/RMX3193:13/SP1A.210812.016/R.14fd79f+1:user/release-keys");
    } else if (prjname == "2167A") {
        set_device_props("RMX3195", "Realme C25S");
        property_override("ro.build.fingerprint",
                          "realme/RMX3195/RMX3195:13/SP1A.210812.016/R.127b622_1:user/release-keys");
    } else if (prjname == "2167C") {
        set_device_props("RMX3195", "Realme C25S");
        property_override("ro.build.fingerprint",
                          "realme/RMX3195/RMX3195:13/SP1A.210812.016/R.127b622_1:user/release-keys");
    } else if (prjname == "2167D") {
        set_device_props("RMX3197", "Realme C25S");
        property_override("ro.build.fingerprint",
                          "realme/RMX3197/RMX3197:13/SP1A.210812.016/R.13d452a-1:user/release-keys");
    } else if (prjname == "216AF") {
        set_device_props("RMX3430", "Realme Narzo 50A");
        property_override("ro.build.fingerprint",
                          "realme/RMX3430/RED8AF:13/SP1A.210812.016/R.182c3f7_cf1b8:user/release-keys");
    }
    load_dalvik_properties();
}

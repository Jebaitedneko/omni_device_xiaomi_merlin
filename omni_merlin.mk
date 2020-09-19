#
# Copyright (C) 2020 The Android Open Source Project
# Copyright (C) 2020 The TWRP Open Source Project
# Copyright (C) 2020 SebaUbuntu's TWRP device tree generator 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# PBRP-10.0 EDITS - START

PRODUCT_RELEASE_NAME := merlin
# PRODUCT_USE_DYNAMIC_PARTITIONS := true
DEVICE_PATH := device/xiaomi/merlin

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit from our custom product configuration
$(call inherit-product, vendor/pb/config/common.mk)

PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(LOCAL_PATH)/recovery/root,recovery/root)

# Inherit PBRP stuff.
$(call inherit-product, vendor/pb/config/common.mk)

# PBRP-10.0 EDITS - END

# Specify phone tech before including full_phone
# $(call inherit-product, vendor/omni/config/gsm.mk)

# Inherit some common Omni stuff.
# $(call inherit-product, vendor/omni/config/common.mk)
# $(call inherit-product, build/target/product/embedded.mk)

# Inherit Telephony packages
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit language packages
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Inherit 64bit support
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := merlin
PRODUCT_NAME := omni_merlin
PRODUCT_BRAND := xiaomi
PRODUCT_MODEL := Xiaomi Redmi Note 9
PRODUCT_MANUFACTURER := xiaomi
PRODUCT_RELEASE_NAME := Xiaomi Redmi Note 9

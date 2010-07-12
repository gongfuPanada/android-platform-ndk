# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Base rules shared to control the build of all modules.
# This should be included from build-binary.mk
#

$(call assert-defined,my LOCAL_BUILD_SCRIPT LOCAL_BUILT_MODULE)

# Compute 'intermediates' which is the location where we're going to store
# intermediate generated files like object (.o) files.
#
intermediates := $($(my)OBJS)

# LOCAL_INTERMEDIATES lists the targets that are generated by this module
#
LOCAL_INTERMEDIATES := $(LOCAL_BUILT_MODULE)

#
# Ensure that 'make <module>' and 'make clean-<module>' work
#
.PHONY: $(LOCAL_MODULE)
$(LOCAL_MODULE): $(LOCAL_BUILT_MODULE)

cleantarget := clean-$(LOCAL_MODULE)-$(TARGET_ARCH_ABI)
.PHONY: $(cleantarget)
clean: $(cleantarget)

$(cleantarget): PRIVATE_MODULE      := $(LOCAL_MODULE)
$(cleantarget): PRIVATE_TEXT        := [$(TARGET_ARCH_ABI)]
$(cleantarget): PRIVATE_CLEAN_FILES := $(LOCAL_BUILT_MODULE) \
                                       $(intermediates)

$(cleantarget)::
	@echo "Clean: $(PRIVATE_MODULE) $(PRIVATE_TEXT)"
	$(hide) rm -rf $(PRIVATE_CLEAN_FILES)

ifeq ($(NDK_APP_DEBUGGABLE),true)
$(NDK_APP_GDBSETUP): PRIVATE_SRC_DIRS += $(LOCAL_C_INCLUDES) $(LOCAL_PATH)
endif

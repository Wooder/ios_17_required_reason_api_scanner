#!/bin/bash

excluded_dirs=() # e.g. ("Pods" "3rdparty")
search_string=(
    # File timestamp APIs
    # https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api#4278393
    "creationDate"
    "creationDateKey"
    "modificationDate"
    "fileModificationDate" 
    "contentModificationDateKey" 
    "creationDateKey"
    "getattrlist\(" 
    "getattrlistbulk\(" 
    "fgetattrlist\(" 
    "stat\(" 
    "stat.st_" # see https://developer.apple.com/documentation/kernel/stat
    "fstat\("
    "fstatat\("
    "lstat\("
    "getattrlistat\("

    # System boot time APIs
    # https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api#4278394
    "systemUptime"
    "mach_absolute_time\(\)"

    # Disk space APIs
    "volumeAvailableCapacityKey"
    "volumeAvailableCapacityForImportantUsageKey"
    "volumeAvailableCapacityForOpportunisticUsageKey"
    "volumeTotalCapacityKey"
    "systemFreeSize"
    "systemSize"
    "statfs\("
    "statvfs\("
    "fstatfs\("
    "fstatvfs\("
    "getattrlist\("
    "fgetattrlist\("
    "getattrlistat\("

    # Active keyboard APIs
    # https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api#4278400
    "activeInputModes"

    # User defaults APIs
    # https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api#4278401
    "^UserDefaults"
    "NSUserDefaults"
    "NSFileCreationDate"
    "NSFileModificationDate"
    "NSFileSystemFreeSize"
    "NSFileSystemSize"
    "NSURLContentModificationDateKey"
    "NSURLCreationDateKey"
    "NSURLVolumeAvailableCapacityForImportantUsageKey"
    "NSURLVolumeAvailableCapacityForOpportunisticUsageKey"
    "NSURLVolumeAvailableCapacityKey"
    "NSURLVolumeTotalCapacityKey"
)

# Match whole words only
rg_opts='--line-number'

# A single -u/--unrestricted flag is equivalent to --no-ignore.
# Two -u/--unrestricted flags is equivalent to --no-ignore -./--hidden.
# Three -u/--unrestricted flags is equivalent to --no-ignore -./--hidden/--binary
rg_opts+=' -uu'

rg_opts+=" --type swift --type objcpp  --type objc"

for dir in "${excluded_dirs[@]}"; do
    rg_opts+=" --glob '!$dir/*'"
done

for string in "${search_string[@]}"; do
    rg_opts+=" -e '$string'"
done

echo "Searching for use of required reason API"
echo "See https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api"

eval "rg $rg_opts $1"
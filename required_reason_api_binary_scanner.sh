#!/bin/bash

set -e

symbols=(
activeInputModes
fgetattrlist
fstat
fstatat
fstatfs
fstatvfs
getattrlist
getattrlistat
getattrlistbulk
lstat
mach_absolute_time
NSFileCreationDate
NSFileModificationDate
NSFileSystemFreeSize
NSFileSystemSize
NSURLContentModificationDateKey
NSURLCreationDateKey
NSURLVolumeAvailableCapacityForImportantUsageKey
NSURLVolumeAvailableCapacityForOpportunisticUsageKey
NSURLVolumeAvailableCapacityKey
NSURLVolumeTotalCapacityKey
NSUserDefaults
stat
statfs
statvfs
systemUptime
)

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function search_binaries_with_directory {
    extension=$1
    for binary in $(find . -iname "*.$extension"); do
        name=$(basename $binary);
        binary_name=$(echo $name | sed "s/.$extension//");
        binaries+=("$(dirname $binary)/${name}/${binary_name}")
    done
}

function search_binaries_with_filename {
    extension=$1
    for binary in $(find . -iname "*.$extension"); do
        binaries+=($binary)
    done
}

cd $1

declare -a binaries

# Adds the .app binary
search_binaries_with_directory app
# Adds the (dynamic/static) .framework binaries
search_binaries_with_directory framework
# Adds the static libs .a binaries
search_binaries_with_filename a

echo "Analyzing binaries: ${binaries[@]}"
echo '---'

for binary in "${binaries[@]}"; do
    if ! [ -f $binary ]; then
        echo "binary '$binary' doesn't exist"
        exit 1
    fi
    used_symbols=()
    for symbol in "${symbols[@]}"; do
        if nm "$binary" 2>/dev/null | xcrun swift-demangle | grep -E "$symbol$" >/dev/null; then
            used_symbols+=($symbol)
        fi
    done
    echo "Used symbols in binary $binary: $(join_by ', ' ${used_symbols[@]})"
done

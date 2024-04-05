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
    tempfile=$(mktemp)
    trap "rm -f $tempfile" EXIT
    find . -iname "*.$extension" -print0 > "$tempfile"
    while IFS= read -r -d '' binary; do
        name=$(basename "$binary")
        binary_name=$(echo "$name" | sed "s/.$extension//")
        binaries+=("$(dirname "$binary")/${name}/${binary_name}")
    done < "$tempfile"
}

function search_binaries_with_filename {
    extension=$1
    tempfile=$(mktemp)
    trap "rm -f $tempfile" EXIT
    find . -iname "*.$extension" -print0 > "$tempfile"
    while IFS= read -r -d '' binary; do
        binaries+=("$binary")
    done < "$tempfile"
}


cd "$1"

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
    if ! [ -f "$binary" ]; then
        echo "binary '$binary' doesn't exist"
        exit 1
    fi
    used_symbols=()
    for symbol in "${symbols[@]}"; do
        if nm "$binary" 2>/dev/null | xcrun swift-demangle | grep -E "$symbol$" >/dev/null; then
            used_symbols+=($symbol)
        fi
    done
    if [ ${#used_symbols[@]} -gt 0 ]; then
        echo "Used symbols in binary $binary: $(join_by ', ' ${used_symbols[@]})"
    fi
done

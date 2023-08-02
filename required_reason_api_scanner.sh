#!/bin/bash

# Array of directories to exclude from the search
excluded_dirs=() # e.g. ("Pods" "3rdparty")

# Global variable for search strings that may indicate a use of "iOS required reason API"
# taken from here: https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api
search_string=(#"creationDate" 
               ".modificationDate" 
               ".fileModificationDate" 
               ".contentModificationDateKey" 
               "getattrlist(" 
               "getattrlistbulk(" 
               "fgetattrlist(" 
               "stat.st_" # see https://developer.apple.com/documentation/kernel/stat
               "fstat("
               "fstatat("
               "lstat("
               "getattrlistat("
               "systemUptime"
               "mach_absolute_time()"
               "volumeAvailableCapacityKey"
               "volumeAvailableCapacityForImportantUsageKey"
               "volumeAvailableCapacityForOpportunisticUsageKey"
               "volumeTotalCapacityKey"
               "systemFreeSize"
               "systemSize"
               "statfs("
               "statvfs("
               "fstatfs("
               "getattrlist("
               "fgetattrlist("
               "getattrlistat("
               "activeInputModes"
               "UserDefaults"
               )

# Function to search for equired reason API strings in a Swift files
search_in_swift_file() {
    local file="$1"

    # Loop through each search string
    for string in "${search_string[@]}"; do
        # Search for the string in the file and get the line numbers
        lines=$(grep -n "$string" "$file" | cut -d ":" -f 1)
        if [ -n "$lines" ]; then
            echo "Found potentially required reason API usage '$string' in '$file'"
            one_line_string=$(echo "$lines" | tr '\n' ' ')
            echo "Line numbers: $one_line_string"
        fi
    done
}

# Function to check if a directory is in the excluded list
is_excluded_dir() {
    local dir_name="$1"
    for excluded_dir in "${excluded_dirs[@]}"; do
        if [ "$dir_name" == "$excluded_dir" ]; then
            return 0
        fi
    done
    return 1
}


# Function to traverse directories recursively and search for Swift files
traverse_and_search() {
    local folder="$1"

    # Get the name of the current directory
    local dir_name=$(basename "$folder")

    # Check if the directory is in the excluded list
    if is_excluded_dir "$dir_name"; then
        return
    fi

    # Loop through each item in the folder
    for item in "$folder"/*; do
        if [ -d "$item" ]; then
            # If it's a directory, call the function recursively
            traverse_and_search "$item"
        elif [ -f "$item" ] && [[ "$item" == *.swift ]]; then
            # If it's a file with .swift extension, search for the strings
            search_in_swift_file "$item"
        fi
    done
}

# Check if a directory path is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory-path>"
    exit 1
fi

# Start the search
echo "Searching for use of required reason API"
echo "See https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api"

traverse_and_search "$1"

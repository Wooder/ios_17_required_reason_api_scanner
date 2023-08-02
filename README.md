Scans the given directory for possible use of "iOS required reason API". 

The scan is very rudimentary and based on comparing strings, but should be very helpful for a first analysis.

See https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api for details.

Usage:

`sh required_reason_api_scanner.sh directory_name`

Example Output:

`Found potentially required reason API usage 'UserDefaults' in './ViewController.swift'
Line numbers: 28`

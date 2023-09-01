Scans the given directory for possible use of "iOS required reason API". 

The scan is very rudimentary and based on comparing strings, but should be very helpful for a first analysis.

See https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api for details.

Usage:

`sh required_reason_api_scanner.sh directory_name`

Example Output:

`Found potentially required reason API usage 'UserDefaults' in './ViewController.swift'
Line numbers: 28`

See the following medium post for more details: https://jochen-holzer.medium.com/embrace-the-evolution-preparing-your-ios-app-for-the-required-reason-api-38f2d12bbce5?source=friends_link&sk=d146c22f3e18c6551231f4b55c934b05

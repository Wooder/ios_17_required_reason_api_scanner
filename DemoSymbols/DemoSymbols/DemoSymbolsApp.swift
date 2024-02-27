//
//  DemoSymbolsApp.swift
//  DemoSymbols
//
//  Created by Omar Zuñiga on 20/12/23.
//

import UIKit
import SwiftUI

@main
struct DemoSymbolsApp: App {
    var body: some Scene {
        WindowGroup {
            Color.clear
        }
    }
    
    init() {
        fgetattrlist(0, nil, nil, 0, 0)
        _ = try? FileManager.default.attributesOfItem(atPath: "").first(where: {
            $0.key == .modificationDate ||
            $0.key == .creationDate ||
            $0.key == .systemFreeSize ||
            $0.key == .systemSize
        })
        fstat(0, nil)
        fstatat(0, nil, nil, 0)
        fstatfs(0, nil)
        fstatvfs(0, nil)
        getattrlist(nil, nil, nil, 0, 0)
        getattrlistat(0, nil, nil, nil, 0, 0)
        getattrlistbulk(0, nil, nil, 0, 0)
        lstat(nil, nil)
        mach_absolute_time()
        
        _ = URLResourceKey.contentModificationDateKey
        _ = URLResourceKey.creationDateKey
        _ = URLResourceKey.volumeAvailableCapacityForImportantUsageKey
        _ = URLResourceKey.volumeAvailableCapacityForOpportunisticUsageKey
        _ = URLResourceKey.volumeAvailableCapacityKey
        _ = URLResourceKey.volumeTotalCapacityKey
        UserDefaults.standard.object(forKey: "")
        _ = stat()
        statfs(nil, nil)
        statvfs(nil, nil)
        
        // Using Swift's `ProcessInfo.processInfo.systemUptime` &
        // `UITextInputMode.activeInputModes` wasn't showing the symbol with `nm`
        // so I force it with ObjC
        let utils = ObjcUtils()
        utils.uptime()
        utils.activeModes()
    }
}

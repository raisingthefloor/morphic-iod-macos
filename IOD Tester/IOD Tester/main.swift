//
//  main.swift
//  IOD Tester
//
//  Created by Stradetch on 3/3/21.
//

import Foundation

print("Initiating Test")

let desktopDir = FileManager.default.urls(for: .desktopDirectory, in: .allDomainsMask)
let testDirectory = FileManager.default.urls(for: .desktopDirectory, in: .allDomainsMask).first!.appendingPathComponent("IOD Test")
let dmgPath = testDirectory.appendingPathComponent("Morphic.dmg")


guard let diskArbitrationSession = DASessionCreate(kCFAllocatorDefault) else {
    print("ERROR: DISK ARBITRATION SESSION CREATE FAILED")
    exit(0)
}

let mount = Process()
mount.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
mount.arguments = ["attach", dmgPath.absoluteURL.absoluteString]
try mount.run()

do {
    sleep(1000)    //placeholder stalling
}

//Diagnostics.Process.Start("/usr/bin/hdiutil", "attach " + dmgPath)

//let disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, diskArbitrationSession, dmgPath as CFURL)

//DADiskMount(<#T##disk: DADisk##DADisk#>, <#T##path: CFURL?##CFURL?#>, <#T##options: DADiskMountOptions##DADiskMountOptions#>, <#T##callback: DADiskMountCallback?##DADiskMountCallback?##(DADisk, DADissenter?, UnsafeMutableRawPointer?) -> Void#>, <#T##context: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)

let name = "Morphic"

let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: .skipHiddenVolumes)!
for volumeURL in mountedVolumeURLs {
    if let disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, diskArbitrationSession, volumeURL as CFURL) {
        if(volumeURL.path.contains("Volumes/Morphic")) {
            let options = DADiskUnmountOptions()
            DADiskUnmount(disk, options, nil, nil)
        }
    }
}

print("Test Complete")


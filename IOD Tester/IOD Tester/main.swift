//
//  main.swift
//  IOD Tester
//
//  Created by Stradetch on 3/3/21.
//

import Foundation
import MorphicIoD

print("Initiating Test")

let desktopDir = FileManager.default.urls(for: .desktopDirectory, in: .allDomainsMask)
let testDirectory = FileManager.default.urls(for: .desktopDirectory, in: .allDomainsMask).first!.appendingPathComponent("IOD Test")
let dmgPath = testDirectory.appendingPathComponent("Morphic.dmg")

let dmg = IoDDMGInstaller()

/*
guard let diskArbitrationSession = DASessionCreate(kCFAllocatorDefault) else {
    print("ERROR: DISK ARBITRATION SESSION CREATE FAILED")
    exit(0)
}
 */

//let mount = Process()
//mount.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
//mount.arguments = ["attach", dmgPath.absoluteURL.absoluteString, "-plist"]
//try mount.run()

if dmg.mount(filepath: dmgPath.absoluteURL.absoluteString) {    //this won't work
    print("Mount Successful")
} else {
    print("Mount Failed")
}



if dmg.mountBackup(filepath: dmgPath.absoluteURL.absoluteString) {  //this works, just calls hdiutil
    print("Mount Successful")
} else {
    print("Mount Failed")
}

sleep(5)    //placeholder stalling


let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: .skipHiddenVolumes)!
for volumeURL in mountedVolumeURLs {
    if(volumeURL.path.contains("Morphic")) {
        //let drivePath = URL(string:volumeURL.path)?.appendingPathComponent("Morphic.app")
        if dmg.copyFile(at: URL(string: "file:///Volumes/Morphic/Morphic.app")!.absoluteURL, to: desktopDir.first!.appendingPathComponent("Morphic.app").absoluteURL) {
            print("Copy Successful")
        } else {
            print("Copy Failed")
        }
    }
}

let name = "Morphic"

if dmg.dismount(name: name) {
    print("Dismount Successful")
} else {
    //print("Dismount Failed")  //the callback isn't working...
}

print("Test Complete")


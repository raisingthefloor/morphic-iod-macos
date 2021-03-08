// Copyright 2020 Raising the Floor - International
//
// Licensed under the New BSD license. You may not use this file except in
// compliance with this License.
//
// You may obtain a copy of the License at
// https://github.com/GPII/universal/blob/master/LICENSE.txt
//
// The R&D leading to these results received funding from the:
// * Rehabilitation Services Administration, US Dept. of Education under
//   grant H421A150006 (APCP)
// * National Institute on Disability, Independent Living, and
//   Rehabilitation Research (NIDILRR)
// * Administration for Independent Living & Dept. of Education under grants
//   H133E080022 (RERC-IT) and H133E130028/90RE5003-01-00 (UIITA-RERC)
// * European Union's Seventh Framework Programme (FP7/2007-2013) grant
//   agreement nos. 289016 (Cloud4all) and 610510 (Prosperity4All)
// * William and Flora Hewlett Foundation
// * Ontario Ministry of Research and Innovation
// * Canadian Foundation for Innovation
// * Adobe Foundation
// * Consumer Electronics Association Foundation

import Foundation
//import DiskImages

public class IoDDMGInstaller {
    
    public init() {
        p_daSession = DASessionCreate(kCFAllocatorDefault)!
        success = 0
        countdown = 0
    }
    
    public func mount(filepath: String) -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/hdiutil")
        process.arguments = ["attach", filepath, "-plist"]
        do {
            try process.run()
        } catch {
            return false;
        }
        return true;
    }
    
    public func dismount(name: String) -> Bool {
        success = 0
        let mountedVolumeURLs = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil, options: .skipHiddenVolumes)!
        for volumeURL in mountedVolumeURLs {
            if let disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, p_daSession, volumeURL as CFURL) {
                if volumeURL.path.contains(name) {
                    let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
                    DADiskUnmount(disk, DADiskUnmountOptions(kDADiskUnmountOptionDefault), {(disk, dissenter, context) in
                        print("DONE")
                        let object = Unmanaged<IoDDMGInstaller>.fromOpaque(context!).takeUnretainedValue()
                        if dissenter != nil {
                            print("LOSE")
                            object.success = -1
                            object.dissent = dissenter
                        }
                        else {
                            print("WIN")
                            object.success = 1
                        }
                    }, context)
                }
            }
        }
        countdown = 1000
        while (success == 0) && countdown > 0 {
            usleep(10000)
            countdown -= 1
        }
        return success > 0
    }
    
    public func dismount() -> Bool {
        return false    //this one is for when I acquire the BSD name from the hdiutil mount code, working on this
    }
    
    public func copyFile(at: URL, to: URL) -> Bool {
        //print(at.absoluteString)
        //print(to.absoluteString)
        do {
            try FileManager.default.copyItem(at: at, to: to)
        } catch {
            return false
        }
        return true
    }
    
    var p_daSession: DASession
    
    var success: Int
    var dissent: DADissenter?
    var countdown: Int
    
}

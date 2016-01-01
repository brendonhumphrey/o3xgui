//
//  TmpKStat.swift
//  kstatviewer
//
//  Created by brendon on 1/01/2016.
//  Copyright © 2016 brendon. All rights reserved.
//

import Cocoa
import OpenZFSInterface

class TmpKStat: NSObject {
    var name : String = ""
    var value : CUnsignedLong = 0

    init(name : String) {
        self.name = name
    }
    
    func valueAsString() -> String {
        return String(value);
    }
    
    func update() {
        value = Sysctl.ulongValue(name)
    }
    
}

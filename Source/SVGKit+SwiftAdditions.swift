//
//  SVGKit+SwiftAdditions.swift
//  SVGKit
//
//  Created by C.W. Betts on 10/14/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

extension SVGKImage {
    class var cacheEnabled: Bool {
        get {
            return isCacheEnabled()
        }
        set {
            if newValue {
                enableCache()
            } else {
                disableCache()
            }
        }
    }
}

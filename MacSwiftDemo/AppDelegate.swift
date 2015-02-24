//
//  AppDelegate.swift
//  MacSwiftDemo
//
//  Created by C.W. Betts on 10/18/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Cocoa
import SVGKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
        SVGKit.enableLogging()
		
		//Don't attempt to use SVGKImageRep: just unload it.
        SVGKImageRep.unloadSVGKImageRep()
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}


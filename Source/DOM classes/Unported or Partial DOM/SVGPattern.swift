//
//  SVGPattern.swift
//  SVGKit
//
//  Created by C.W. Betts on 2/4/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(OSX)
	import Cocoa
	#elseif os(iOS)
	import UIKit
#endif

@objc(SVGPattern) public class SVGPattern: NSObject {
	var color: CGColorRef
	
	public init(cgColor: CGColor) {
		color = cgColor
		
		super.init()
	}
	/*
+ (SVGKPattern*)patternWithCGColor:(CGColorRef)cgColor
{
SVGKPattern *p = [[SVGKPattern alloc] init];

p.color = cgColor;

return p;
}
*/
	override init() {
		color = CGColorCreateGenericRGB(1, 1, 1, 1)
		super.init()
	}
	
}

//
//  SVGKit+SwiftAdditions.swift
//  SVGKit
//
//  Created by C.W. Betts on 10/14/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGKNodeList: SequenceType {
	public func generate() -> IndexingGenerator<[SVGKNode]> {
		return (internalArray as NSArray as [SVGKNode]).generate()
	}
}

extension SVGKImage {
	public class var cacheEnabled: Bool {
		get {
			return isCacheEnabled()
		}
		set {
			if cacheEnabled == newValue {
				return
			}
			if newValue {
				enableCache()
			} else {
				disableCache()
			}
		}
	}
}

extension SVGKCSSRuleList: SequenceType {
	public func generate() -> IndexingGenerator<[SVGKCSSRule]> {
		return (internalArray as NSArray as [SVGKCSSRule]).generate()
	}
}

extension SVGKStyleSheetList: SequenceType {
	public func generate() -> NSFastGenerator {
		return NSFastGenerator(self)
	}
}

public func ==(lhs: SVGCurve, rhs: SVGCurve) -> Bool {
	return SVGCurveEqualToCurve(lhs, rhs)
}

extension SVGCurve: Equatable {
	public init() {
		c1 = CGPoint.zeroPoint
		c2 = CGPoint.zeroPoint
		p = CGPoint.zeroPoint
	}

	public init(cx1: Int, cy1: Int, cx2: Int, cy2: Int, px: Int, py: Int) {
		self = SVGCurveMake(CGFloat(cx1), CGFloat(cy1), CGFloat(cx2), CGFloat(cy2), CGFloat(px), CGFloat(py))
	}
	
	public init(cx1: Float, cy1: Float, cx2: Float, cy2: Float, px: Float, py: Float) {
		self = SVGCurveMake(CGFloat(cx1), CGFloat(cy1), CGFloat(cx2), CGFloat(cy2), CGFloat(px), CGFloat(py))
	}
	
	public init(cx1: CGFloat, cy1: CGFloat, cx2: CGFloat, cy2: CGFloat, px: CGFloat, py: CGFloat) {
		self = SVGCurveMake(cx1, cy1, cx2, cy2, px, py)
	}
}

extension SVGRect {
	public init() {
		self = SVGRectUninitialized()
	}
	
	public var initialized: Bool {
		return SVGRectIsInitialized(self)
	}
}

extension SVGColor {
	public init(string: String) {
		self = SVGColorFromString(string)
	}
	
	public var cgColor: CGColor {
		return CGColorWithSVGColor(self)
	}
}

#if os(OSX)
extension SVGKImageRep {
	
}
#endif

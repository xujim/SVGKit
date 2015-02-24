//
//  SVGKit+SwiftAdditions.swift
//  SVGKit
//
//  Created by C.W. Betts on 10/14/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics
import SVGKit.SVGKStyleSheetList

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

extension SVGRect: Equatable {
	/// Returns an uninitialized SVGRect
	public init() {
		self = SVGRectUninitialized()
	}
	
	public var initialized: Bool {
		return SVGRectIsInitialized(self)
	}
	
	/// Convenience variable to convert to ObjectiveC's kind of rect
	public var cgRect: CGRect {
		return CGRectFromSVGRect(self)
	}
	
	/// Convenience variable to convert to ObjectiveC's kind of size - <b>Only</b> the width and height of this rect.
	public var cgSize: CGSize {
		return CGSizeFromSVGRect(self)
	}
}

extension SVGColor: Equatable {
	public init(string: String) {
		self = SVGColorFromString(string)
	}
	
	public init() {
		r = 0; g = 0; b = 0; a = 0;
	}
	
	public var cgColor: CGColor {
		return CGColorWithSVGColor(self)
	}
}

#if os(OSX)
extension SVGKImageRep {
	
}
#endif

public func ==(lhs: SVGRect, rhs: SVGRect) -> Bool {
	if lhs.x != rhs.x {
		return false
	} else if lhs.y != rhs.y {
		return false
	} else if lhs.height != rhs.height {
		return false
	} else if lhs.width != rhs.width {
		return false
	} else {
		return true
	}
}

public func ==(lhs: SVGColor, rhs: SVGColor) -> Bool {
	if lhs.r != rhs.r {
		return false
	} else if lhs.g != rhs.g {
		return false
	} else if lhs.b != rhs.b {
		return false
	} else if lhs.a != rhs.a {
		return false
	} else {
		return true
	}
}

public func ==(lhs: SVGCurve, rhs: SVGCurve) -> Bool {
	return SVGCurveEqualToCurve(lhs, rhs)
}

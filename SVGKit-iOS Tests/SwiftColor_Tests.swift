//
//  SwiftColor_Tests.swift
//  SVGKit
//
//  Created by C.W. Betts on 3/18/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import XCTest
import SVGKit

private let gColorDict = [
	"aliceblue": SVGColor(red: 240, green: 248, blue: 255),
	"antiquewhite": SVGColor(red: 250, green: 235, blue: 215),
	"aqua": SVGColor(red: 0, green: 255, blue: 255),
	"aquamarine": SVGColor(red: 127, green: 255, blue: 212),
	"azure": SVGColor(red: 240, green: 255, blue: 255),
	"beige": SVGColor(red: 245, green: 245, blue: 220),
	"bisque": SVGColor(red: 255, green: 228, blue: 196),
	"black": SVGColor(red: 0, green: 0, blue: 0),
	"blanchedalmond": SVGColor(red: 255, green: 235, blue: 205),
	"blue": SVGColor(red: 0, green: 0, blue: 255),
	"blueviolet": SVGColor(red: 138, green: 43, blue: 226),
	"brown": SVGColor(red: 165, green: 42, blue: 42),
	"burlywood": SVGColor(red: 222, green: 184, blue: 135),
	"cadetblue": SVGColor(red: 95, green: 158, blue: 160),
	"chartreuse": SVGColor(red: 127, green: 255, blue: 0),
	"chocolate": SVGColor(red: 210, green: 105, blue: 30),
	"coral": SVGColor(red: 255, green: 127, blue: 80),
	"cornflowerblue": SVGColor(red: 100, green: 149, blue: 237),
	"cornsilk": SVGColor(red: 255, green: 248, blue: 220),
	"crimson": SVGColor(red: 220, green: 20, blue: 60),
	"cyan": SVGColor(red: 0, green: 255, blue: 255),
	"darkblue": SVGColor(red: 0, green: 0, blue: 139),
	"darkcyan": SVGColor(red: 0, green: 139, blue: 139),
	"darkgoldenrod": SVGColor(red: 184, green: 134, blue: 11),
	"darkgray": SVGColor(red: 169, green: 169, blue: 169),
	"darkgreen": SVGColor(red: 0, green: 100, blue: 0),
	"darkgrey": SVGColor(red: 169, green: 169, blue: 169),
	"darkkhaki": SVGColor(red: 189, green: 183, blue: 107),
	"darkmagenta": SVGColor(red: 139, green: 0, blue: 139),
	"darkolivegreen": SVGColor(red: 85, green: 107, blue: 47),
	"darkorange": SVGColor(red: 255, green: 140, blue: 0),
	"darkorchid": SVGColor(red: 153, green: 50, blue: 204),
	"darkred": SVGColor(red: 139, green: 0, blue: 0),
	"darksalmon": SVGColor(red: 233, green: 150, blue: 122),
	"darkseagreen": SVGColor(red: 143, green: 188, blue: 143),
	"darkslateblue": SVGColor(red: 72, green: 61, blue: 139),
	"darkslategray": SVGColor(red: 47, green: 79, blue: 79),
	"darkslategrey": SVGColor(red: 47, green: 79, blue: 79),
	"darkturquoise": SVGColor(red: 0, green: 206, blue: 209),
	"darkviolet": SVGColor(red: 148, green: 0, blue: 211),
	"deeppink": SVGColor(red: 255, green: 20, blue: 147),
	"deepskyblue": SVGColor(red: 0, green: 191, blue: 255),
	"dimgray": SVGColor(red: 105, green: 105, blue: 105),
	"dimgrey": SVGColor(red: 105, green: 105, blue: 105),
	"dodgerblue": SVGColor(red: 30, green: 144, blue: 255),
	"firebrick": SVGColor(red: 178, green: 34, blue: 34),
	"floralwhite": SVGColor(red: 255, green: 250, blue: 240),
	"forestgreen": SVGColor(red: 34, green: 139, blue: 34),
	"fuchsia": SVGColor(red: 255, green: 0, blue: 255),
	"gainsboro": SVGColor(red: 220, green: 220, blue: 220),
	"ghostwhite": SVGColor(red: 248, green: 248, blue: 255),
	"gold": SVGColor(red: 255, green: 215, blue: 0),
	"goldenrod": SVGColor(red: 218, green: 165, blue: 32),
	"gray": SVGColor(red: 128, green: 128, blue: 128),
	"green": SVGColor(red: 0, green: 128, blue: 0),
	"greenyellow": SVGColor(red: 173, green: 255, blue: 47),
	"grey": SVGColor(red: 128, green: 128, blue: 128),
	"honeydew": SVGColor(red: 240, green: 255, blue: 240),
	"hotpink": SVGColor(red: 255, green: 105, blue: 180),
	"indianred": SVGColor(red: 205, green: 92, blue: 92),
	"indigo": SVGColor(red: 75, green: 0, blue: 130),
	"ivory": SVGColor(red: 255, green: 255, blue: 240),
	"khaki": SVGColor(red: 240, green: 230, blue: 140),
	"lavender": SVGColor(red: 230, green: 230, blue: 250),
	"lavenderblush": SVGColor(red: 255, green: 240, blue: 245),
	"lawngreen": SVGColor(red: 124, green: 252, blue: 0),
	"lemonchiffon": SVGColor(red: 255, green: 250, blue: 205),
	"lightblue": SVGColor(red: 173, green: 216, blue: 230),
	"lightcoral": SVGColor(red: 240, green: 128, blue: 128),
	"lightcyan": SVGColor(red: 224, green: 255, blue: 255),
	"lightgoldenrodyellow": SVGColor(red: 250, green: 250, blue: 210),
	"lightgray": SVGColor(red: 211, green: 211, blue: 211),
	"lightgreen": SVGColor(red: 144, green: 238, blue: 144),
	"lightgrey": SVGColor(red: 211, green: 211, blue: 211),
	"lightpink": SVGColor(red: 255, green: 182, blue: 193),
	"lightsalmon": SVGColor(red: 255, green: 160, blue: 122),
	"lightseagreen": SVGColor(red: 32, green: 178, blue: 170),
	"lightskyblue": SVGColor(red: 135, green: 206, blue: 250),
	"lightslategray": SVGColor(red: 119, green: 136, blue: 153),
	"lightslategrey": SVGColor(red: 119, green: 136, blue: 153),
	"lightsteelblue": SVGColor(red: 176, green: 196, blue: 222),
	"lightyellow": SVGColor(red: 255, green: 255, blue: 224),
	"lime": SVGColor(red: 0, green: 255, blue: 0),
	"limegreen": SVGColor(red: 50, green: 205, blue: 50),
	"linen": SVGColor(red: 250, green: 240, blue: 230),
	"magenta": SVGColor(red: 255, green: 0, blue: 255),
	"maroon": SVGColor(red: 128, green: 0, blue: 0),
	"mediumaquamarine": SVGColor(red: 102, green: 205, blue: 170),
	"mediumblue": SVGColor(red: 0, green: 0, blue: 205),
	"mediumorchid": SVGColor(red: 186, green: 85, blue: 211),
	"mediumpurple": SVGColor(red: 147, green: 112, blue: 219),
	"mediumseagreen": SVGColor(red: 60, green: 179, blue: 113),
	"mediumslateblue": SVGColor(red: 123, green: 104, blue: 238),
	"mediumspringgreen": SVGColor(red: 0, green: 250, blue: 154),
	"mediumturquoise": SVGColor(red: 72, green: 209, blue: 204),
	"mediumvioletred": SVGColor(red: 199, green: 21, blue: 133),
	"midnightblue": SVGColor(red: 25, green: 25, blue: 112),
	"mintcream": SVGColor(red: 245, green: 255, blue: 250),
	"mistyrose": SVGColor(red: 255, green: 228, blue: 225),
	"moccasin": SVGColor(red: 255, green: 228, blue: 181),
	"navajowhite": SVGColor(red: 255, green: 222, blue: 173),
	"navy": SVGColor(red: 0, green: 0, blue: 128),
	"oldlace": SVGColor(red: 253, green: 245, blue: 230),
	"olive": SVGColor(red: 128, green: 128, blue: 0),
	"olivedrab": SVGColor(red: 107, green: 142, blue: 35),
	"orange": SVGColor(red: 255, green: 165, blue: 0),
	"orangered": SVGColor(red: 255, green: 69, blue: 0),
	"orchid": SVGColor(red: 218, green: 112, blue: 214),
	"palegoldenrod": SVGColor(red: 238, green: 232, blue: 170),
	"palegreen": SVGColor(red: 152, green: 251, blue: 152),
	"paleturquoise": SVGColor(red: 175, green: 238, blue: 238),
	"palevioletred": SVGColor(red: 219, green: 112, blue: 147),
	"papayawhip": SVGColor(red: 255, green: 239, blue: 213),
	"peachpuff": SVGColor(red: 255, green: 218, blue: 185),
	"peru": SVGColor(red: 205, green: 133, blue: 63),
	"pink": SVGColor(red: 255, green: 192, blue: 203),
	"plum": SVGColor(red: 221, green: 160, blue: 221),
	"powderblue": SVGColor(red: 176, green: 224, blue: 230),
	"purple": SVGColor(red: 128, green: 0, blue: 128),
	"red": SVGColor(red: 255, green: 0, blue: 0),
	"rosybrown": SVGColor(red: 188, green: 143, blue: 143),
	"royalblue": SVGColor(red: 65, green: 105, blue: 225),
	"saddlebrown": SVGColor(red: 139, green: 69, blue: 19),
	"salmon": SVGColor(red: 250, green: 128, blue: 114),
	"sandybrown": SVGColor(red: 244, green: 164, blue: 96),
	"seagreen": SVGColor(red: 46, green: 139, blue: 87),
	"seashell": SVGColor(red: 255, green: 245, blue: 238),
	"sienna": SVGColor(red: 160, green: 82, blue: 45),
	"silver": SVGColor(red: 192, green: 192, blue: 192),
	"skyblue": SVGColor(red: 135, green: 206, blue: 235),
	"slateblue": SVGColor(red: 106, green: 90, blue: 205),
	"slategray": SVGColor(red: 112, green: 128, blue: 144),
	"slategrey": SVGColor(red: 112, green: 128, blue: 144),
	"snow": SVGColor(red: 255, green: 250, blue: 250),
	"springgreen": SVGColor(red: 0, green: 255, blue: 127),
	"steelblue": SVGColor(red: 70, green: 130, blue: 180),
	"tan": SVGColor(red: 210, green: 180, blue: 140),
	"teal": SVGColor(red: 0, green: 128, blue: 128),
	"thistle": SVGColor(red: 216, green: 191, blue: 216),
	"tomato": SVGColor(red: 255, green: 99, blue: 71),
	"turquoise": SVGColor(red: 64, green: 224, blue: 208),
	"violet": SVGColor(red: 238, green: 130, blue: 238),
	"wheat": SVGColor(red: 245, green: 222, blue: 179),
	"white": SVGColor(red: 255, green: 255, blue: 255),
	"whitesmoke": SVGColor(red: 245, green: 245, blue: 245),
	"yellow": SVGColor(red: 255, green: 255, blue: 0),
	"yellowgreen": SVGColor(red: 154, green: 205, blue: 50)
]

private var gColorValues: [SVGColor] = {
	var toRet = [SVGColor]()
	//var names = gColorDict.keys.array
	let names = gColorNames
	
	#if false
	names.sort( {
		return $0 < $1
	})
	#endif
	
	for name in names {
		toRet.append(gColorDict[name]!)
	}
	
	return toRet
}()

private let gColorNames = [
	"aliceblue",
	"antiquewhite",
	"aqua",
	"aquamarine",
	"azure",
	"beige",
	"bisque",
	"black",
	"blanchedalmond",
	"blue",
	"blueviolet",
	"brown",
	"burlywood",
	"cadetblue",
	"chartreuse",
	"chocolate",
	"coral",
	"cornflowerblue",
	"cornsilk",
	"crimson",
	"cyan",
	"darkblue",
	"darkcyan",
	"darkgoldenrod",
	"darkgray",
	"darkgreen",
	"darkgrey",
	"darkkhaki",
	"darkmagenta",
	"darkolivegreen",
	"darkorange",
	"darkorchid",
	"darkred",
	"darksalmon",
	"darkseagreen",
	"darkslateblue",
	"darkslategray",
	"darkslategrey",
	"darkturquoise",
	"darkviolet",
	"deeppink",
	"deepskyblue",
	"dimgray",
	"dimgrey",
	"dodgerblue",
	"firebrick",
	"floralwhite",
	"forestgreen",
	"fuchsia",
	"gainsboro",
	"ghostwhite",
	"gold",
	"goldenrod",
	"gray",
	"green",
	"greenyellow",
	"grey",
	"honeydew",
	"hotpink",
	"indianred",
	"indigo",
	"ivory",
	"khaki",
	"lavender",
	"lavenderblush",
	"lawngreen",
	"lemonchiffon",
	"lightblue",
	"lightcoral",
	"lightcyan",
	"lightgoldenrodyellow",
	"lightgray",
	"lightgreen",
	"lightgrey",
	"lightpink",
	"lightsalmon",
	"lightseagreen",
	"lightskyblue",
	"lightslategray",
	"lightslategrey",
	"lightsteelblue",
	"lightyellow",
	"lime",
	"limegreen",
	"linen",
	"magenta",
	"maroon",
	"mediumaquamarine",
	"mediumblue",
	"mediumorchid",
	"mediumpurple",
	"mediumseagreen",
	"mediumslateblue",
	"mediumspringgreen",
	"mediumturquoise",
	"mediumvioletred",
	"midnightblue",
	"mintcream",
	"mistyrose",
	"moccasin",
	"navajowhite",
	"navy",
	"oldlace",
	"olive",
	"olivedrab",
	"orange",
	"orangered",
	"orchid",
	"palegoldenrod",
	"palegreen",
	"paleturquoise",
	"palevioletred",
	"papayawhip",
	"peachpuff",
	"peru",
	"pink",
	"plum",
	"powderblue",
	"purple",
	"red",
	"rosybrown",
	"royalblue",
	"saddlebrown",
	"salmon",
	"sandybrown",
	"seagreen",
	"seashell",
	"sienna",
	"silver",
	"skyblue",
	"slateblue",
	"slategray",
	"slategrey",
	"snow",
	"springgreen",
	"steelblue",
	"tan",
	"teal",
	"thistle",
	"tomato",
	"turquoise",
	"violet",
	"wheat",
	"white",
	"whitesmoke",
	"yellow",
	"yellowgreen"
]

class SwiftColor_Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	lazy var SVGcolorDict: [String: SVGColor] = self.colorDictionary()
	
	func colorDictionary() -> [String: SVGColor] {
		var toRetArray = [String: SVGColor]()
		
		for colorName in gColorNames {
			toRetArray[colorName] = SVGColor(string: colorName)
		}
		return toRetArray
	}

    func testCColorPerformance() {
		
		//measure the block for populating a color array with the C Function
		self.measureBlock() {
			var cLookupArray = [SVGColor]()
			for strColor in gColorNames {
				var aColor = SVGColorFromString(strColor)
				cLookupArray.append(aColor)
			}
        }
	}
	
	func testCColorEquality() {
		var cLookupArray = [SVGColor]()

		for strColor in gColorNames {
			var aColor = SVGColorFromString(strColor)
			cLookupArray.append(aColor)
		}
		
		for i in 0 ..< cLookupArray.count {
			XCTAssertEqual(cLookupArray[i], gColorValues[i])
		}
		XCTAssertEqual(cLookupArray, gColorValues)
	}
	
	func testSwiftColorPerformance() {

		self.measureBlock() {
			let colorDict = self.colorDictionary()
			var swiftLookupArray = [SVGColor]()

			for strColor in gColorNames {
				if let aColor = colorDict[strColor] {
					swiftLookupArray.append(aColor)
				} else {
					XCTAssert(false, "Got wrong value")
				}
			}
		}
	}
	
	func testSwiftColorEquality() {
		var swiftLookupArray = [SVGColor]()

		for strColor in gColorNames {
			if let aColor = SVGcolorDict[strColor] {
				swiftLookupArray.append(aColor)
			} else {
				XCTAssert(false, "Got wrong value")
			}
		}
		
		XCTAssertEqual(swiftLookupArray, gColorValues)
	}
}

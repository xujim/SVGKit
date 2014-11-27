//
//  FastImageViewRetainTests.m
//  SVGKit-iOS
//
//  Created by C.W. Betts on 11/26/14.
//  Copyright (c) 2014 na. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SVGKit.h"

@interface FastImageViewRetainTests : XCTestCase
@property (strong) NSBundle *pathsToSVGs;
@end

@implementation FastImageViewRetainTests

- (void)setUp {
	[super setUp];
	
	self.pathsToSVGs = [NSBundle bundleForClass:[self class]];
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testImageViewInitializers
{
	@try {
		@autoreleasepool {
			SVGKImage *note = [SVGKImage imageWithContentsOfFile:[self.pathsToSVGs pathForResource:@"Note" ofType:@"svg"]];
			SVGKImage *monkey = [[SVGKImage alloc] initWithContentsOfFile:[self.pathsToSVGs pathForResource:@"Monkey" ofType:@"svg"]];
			SVGKFastImageView *imageWithSVGKImage = [[SVGKFastImageView alloc] initWithSVGKImage:note];
			imageWithSVGKImage.disableAutoRedrawAtHighestResolution = YES;
			imageWithSVGKImage.image = monkey;
			CGSize aSize = imageWithSVGKImage.intrinsicContentSize;
			NSLog(@"intrinsicContentSize: %@", NSStringFromCGSize(aSize));
		}
		XCTAssertTrue(YES);
	}
	@catch (NSException *exception) {
		XCTFail(@"Exception Thrown: %@", exception);
	}
}

@end

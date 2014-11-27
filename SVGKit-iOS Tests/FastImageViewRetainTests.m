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
	XCTAssertNoThrow({
	@autoreleasepool {
		SVGKImage *note = [SVGKImage imageWithContentsOfFile:[self.pathsToSVGs pathForResource:@"Note" ofType:@"svg"]];
		SVGKFastImageView *imageWithSVGKImage = [[SVGKFastImageView alloc] initWithSVGKImage:note];
		CGSize aSize = imageWithSVGKImage.intrinsicContentSize;
		NSLog(@"intrinsicContentSize: %@", NSStringFromCGSize(aSize));
	}});
}

@end

//
//  SVGPatternElement.m
//  SVGKit-iOS
//
//  Created by C.W. Betts on 6/13/13.
//  Copyright (c) 2013 na. All rights reserved.
//

#import "SVGPatternElement.h"

#if TARGET_OS_IPHONE
#define DWPImageFromSVGKImage(dwp) [dwp UIImage] 
#else
#define DWPImageFromSVGKImage(dwp) [dwp NSImage]
#endif


@interface SVGPatternElement ()
@property (readwrite, retain, nonatomic) DWPImage *patternImage;
@property (readwrite, nonatomic) CGFloat width;
@property (readwrite, nonatomic) CGFloat height;

@end

@implementation SVGPatternElement

@synthesize transform = _transform;

- (SVGKPattern *)pattern
{
	return [SVGKPattern patternWithImage:self.patternImage];
}

- (CGColorRef)colorPattern
{
	return self.pattern.CGColor;
}

- (void)dealloc
{
    self.patternImage = nil;
	
    [super dealloc];
}
@end

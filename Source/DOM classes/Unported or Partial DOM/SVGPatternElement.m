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
@property (readwrite, strong, nonatomic) DWPImage *patternImage;
@property (nonatomic, strong, readwrite) SVGLength* width;
@property (nonatomic, strong, readwrite) SVGLength* height;
@property (nonatomic, strong, readwrite) SVGLength* x;
@property (nonatomic, strong, readwrite) SVGLength* y;


@end

@implementation SVGPatternElement

@synthesize transform = _transform;
@synthesize width = _width;
@synthesize height = _height;
@synthesize x = _x;
@synthesize y = _y;

- (SVGKPattern *)pattern
{
	return [SVGKPattern patternWithImage:self.patternImage];
}

- (CGColorRef)colorPattern
{
	return self.pattern.color;
}

@end

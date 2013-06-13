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
@end

@implementation SVGPatternElement

@synthesize transform = _transform;

- (SVGKPattern *)imagePattern
{
	return [SVGKPattern patternWithImage:self.patternImage];
}

- (void)dealloc
{
    self.patternImage = nil;
	
    [super dealloc];
}
@end

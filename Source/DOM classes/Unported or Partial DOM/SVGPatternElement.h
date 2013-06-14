//
//  SVGPatternElement.h
//  SVGKit-iOS
//
//  Created by C.W. Betts on 6/13/13.
//  Copyright (c) 2013 na. All rights reserved.
//

#import "SVGElement.h"

#import "SVGRect.h"
#import "SVGGradientStop.h"
#import "SVGTransformable.h"
#import "SVGKPattern.h"

#if TARGET_OS_IPHONE
#define DWPImage UIImage
#else
#define DWPImage NSImage
#endif


@interface SVGPatternElement : SVGElement <SVGTransformable>

@property (readonly, retain, nonatomic) DWPImage *patternImage;
@property (readonly, nonatomic) SVGKPattern *pattern;
@property (nonatomic, retain, readonly) SVGLength* width;
@property (nonatomic, retain, readonly) SVGLength* height;

- (CGColorRef)colorPattern;

@end

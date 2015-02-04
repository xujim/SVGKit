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

@class SVGPattern;

@interface SVGPatternElement : SVGElement <SVGTransformable>

@property (readonly, strong, nonatomic) DWPImage *patternImage;
@property (readonly, strong, nonatomic) SVGKPattern *pattern;
@property (nonatomic, strong, readonly) SVGLength* width;
@property (nonatomic, strong, readonly) SVGLength* height;
@property (nonatomic, strong, readonly) SVGLength* x;
@property (nonatomic, strong, readonly) SVGLength* y;

- (CGColorRef)colorPattern;

@end

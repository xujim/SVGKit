#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#else

#import <Cocoa/Cocoa.h>

#endif

/** lightweight wrapper for UIColor so that we can draw with fill patterns */
@interface SVGKPattern : NSObject
@property (readwrite, nonatomic) CGColorRef color;

+ (instancetype)patternWithCGImage:(CGImageRef)cgImage;
+ (instancetype)patternWithCGColor:(CGColorRef)cgColor;

@property (nonatomic, readonly) CGColorRef CGColor CF_RETURNS_NOT_RETAINED;

#if TARGET_OS_IPHONE

+ (instancetype)patternWithUIColor:(UIColor*)color;
+ (instancetype)patternWithImage:(UIImage*)image;

#else

+ (instancetype)patternWithNSColor:(NSColor*)color;
+ (instancetype)patternWithImage:(NSImage*)image;

#endif

@end

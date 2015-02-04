#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#else

#import <Cocoa/Cocoa.h>

#endif

/** lightweight wrapper for UIColor so that we can draw with fill patterns */
@interface SVGKPattern : NSObject
@property (nonatomic, readonly) CGColorRef color NS_RETURNS_INNER_POINTER;

+ (instancetype)patternWithCGImage:(CGImageRef)cgImage;
+ (instancetype)patternWithCGColor:(CGColorRef)cgColor;

#if TARGET_OS_IPHONE

+ (instancetype)patternWithUIColor:(UIColor*)color;
+ (instancetype)patternWithImage:(UIImage*)image;

#else

+ (instancetype)patternWithNSColor:(NSColor*)color;
+ (instancetype)patternWithImage:(NSImage*)image;

#endif

@end

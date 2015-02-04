#import "SVGKPattern.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "TBColor.h"

@interface SVGKPattern ()
@property (strong) TBColor* internalColor;
@end

@implementation SVGKPattern

- (CGColorRef)color
{
	return _internalColor.CGColor;
}

- (instancetype)initWithTBColor:(TBColor*)aColor
{
	if (self = [super init]) {
		self.internalColor = aColor;
	}
	return self;
}

- (instancetype)initWithCGImage:(CGImageRef)cgImage
{
	return [self initWithTBColor:[[TBColor alloc] initWithPatternCGImage:cgImage]];
}

- (instancetype)initWithCGColor:(CGColorRef)cgColor
{
	return [self initWithTBColor:[[TBColor alloc] initWithCGColor:cgColor]];
}

+ (SVGKPattern*)patternWithCGImage:(CGImageRef)cgImage
{
	return [[SVGKPattern alloc] initWithCGImage:cgImage];
}

+ (SVGKPattern*)patternWithCGColor:(CGColorRef)cgColor
{
	return [[SVGKPattern alloc] initWithCGColor:cgColor];
}

#if TARGET_OS_IPHONE

+ (SVGKPattern *)patternWithUIColor:(UIColor *)color
{
	return [self patternWithCGColor:[color CGColor]];
}

+ (SVGKPattern*)patternWithImage:(UIImage*)image
{
    return [self patternWithUIColor:[[UIColor alloc] initWithPatternImage:image]];
}

#else

+ (SVGKPattern*)patternWithImage:(NSImage*)image
{
	return [[SVGKPattern alloc] initWithTBColor:[[TBColor alloc] initWithPatternImage:image]];
}


+ (SVGKPattern*)patternWithNSColor:(NSColor*)color
{
	return [self patternWithCGColor:color.CGColor];
}

#endif

@end

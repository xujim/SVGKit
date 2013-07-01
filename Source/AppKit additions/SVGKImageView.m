#import "SVGKImageView.h"

@implementation SVGKImageView

//@synthesize image = _image;
@synthesize showBorder = _showBorder;


- (id)initWithSVGKImage:(SVGKImage*)im frame:(NSRect)theFrame
{
	if ([self isMemberOfClass:[SVGKImageView class]]) {
		DDLogError(@"[%@] ERROR: The function %s is meant to be implemented from a subclass, but you called the %@ class directly. This is not a good thing.", [self class], sel_getName(_cmd), [SVGKImageView class]);
	} else {
		DDLogError(@"[%@] ERROR: The function %s should be implemented by the subclass %@. You are currently using the function from %@, which is not good.", [self class], sel_getName(_cmd), [self class], [SVGKImageView class]);
	}
	return nil;
}

- (id)init
{
	if( [self isMemberOfClass:[SVGKImageView class]])
	{
		DDLogError(@"[%@] ERROR: You cannot init this class directly. Instead, use a subclass e.g. SVGKLayeredImageView.", [self class]);
		
		return nil;
	}
	else
		return [super init];
}

- (void)setImage:(SVGKImage*)image
{
	NSAssert(NO, @"[%@] The function %s should be implemented by the subclass %@. You are currently using the function from %@, which is not good.", [self class], sel_getName(_cmd), [self class], [SVGKImageView class]);
}

- (SVGKImage *)image
{
	NSAssert(NO, @"[%@] The function %s should be implemented by the subclass %@. You are currently using the function from %@, which is not good.", [self class], sel_getName(_cmd), [self class], [SVGKImageView class]);
	return nil;
}

-(id)initWithFrame:(NSRect)frame
{
	if( [self isMemberOfClass:[SVGKImageView class]])
	{
		DDLogError(@"[%@] ERROR: You cannot init this class directly. Instead, use a subclass e.g. SVGKLayeredImageView.", [self class]);
		
		return nil;
	}
	else
		return [super initWithFrame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if( [self isMemberOfClass:[SVGKImageView class]])
	{
		DDLogError(@"[%@] ERROR: Xcode is trying to load this class from a NIB file. You cannot init this class directly - in your NIB file, set the Class type to one of the subclasses, e.g. SVGKLayeredImageView", [self class]);
		
		return nil;
	}
	else
		return [super initWithCoder:aDecoder];
}

- (id)initWithSVGKImage:(SVGKImage*) im
{
	if( [self isMemberOfClass:[SVGKImageView class]])
	{
		DDLogError(@"[%@] ERROR: You cannot init this class directly: use a subclass like SVGKLayeredImageView.", [self class]);
		
		return nil;
	} else {
		DDLogError(@"[%@] ERROR: Your subclass implementation is broken, as it is calling %s from %@. This may be due to the subclass calling -[super initWithSVGKImage] or the subclass does not implementing the function. If you are calling -[super initWithSVGKImage:], call -[super init] instead.", [self class], sel_getName(_cmd), [SVGKImageView class]);
	}
	
    return nil;
}

- (BOOL)isFlipped
{
	return YES;
}

@end

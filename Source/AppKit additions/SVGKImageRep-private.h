
#import "SVGKImageRep.h"

@interface SVGKImageRep ()

@property BOOL antiAlias;
@property CGFloat curveFlatness;
@property CGInterpolationQuality interpolationQuality;

- (instancetype)initWithSVGImage:(SVGKImage*)theImage copy:(BOOL)copyImage;
// init methods inherited from NSImageRep
- (instancetype)initWithCoder:(NSCoder *)coder;

@end


#import "SVGKStyleSheetList.h"
#import "SVGKStyleSheetList+Mutable.h"

@implementation SVGKStyleSheetList

@synthesize internalArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.internalArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSUInteger)length
{
	return self.internalArray.count;
}

-(SVGKStyleSheet*) item:(NSUInteger) index
{
	return (self.internalArray)[index];
}

@end

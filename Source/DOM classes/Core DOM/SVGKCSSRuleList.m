#import "SVGKCSSRuleList.h"
#import "SVGKCSSRuleList+Mutable.h"

@implementation SVGKCSSRuleList

@synthesize internalArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.internalArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(unsigned long)length
{
	return self.internalArray.count;
}

-(SVGKCSSRule *)item:(unsigned long)index
{
	return (self.internalArray)[index];
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"CSSRuleList: array(%@)", self.internalArray];
}

@end

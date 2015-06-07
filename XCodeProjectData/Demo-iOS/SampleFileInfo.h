#import <Foundation/Foundation.h>

#import <SVGKit/SVGKSource.h>

@interface SampleFileInfo : NSObject

@property(nonatomic,retain) NSString* author, * licenseType, * name;

@property(nonatomic,readonly) SVGKSource* source;

-(SVGKSource*) sourceFromWeb;
-(SVGKSource*) sourceFromLocalFile;

-(NSString*) savedBitmapFilename;

+(instancetype) sampleFileInfoWithFilename:(NSString*) f;
+(instancetype) sampleFileInfoWithURL:(NSURL*) s;
+(instancetype) sampleFileInfoWithFilename:(NSString*) f URL:(NSURL*) s;

@end

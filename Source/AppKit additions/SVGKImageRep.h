//
//  SVGKImageRep.h
//  SVGKit-OSX
//
//  Created by C.W. Betts on 11/21/13.
//  Copyright (c) 2013 C.W. Betts. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SVGKImage;
@class SVGKSource;

@interface SVGKImageRep : NSImageRep
@property (nonatomic, retain, readonly) SVGKImage *image;

//Function used by NSImageRep to init.
+ (instancetype)imageRepWithData:(NSData *)d;
+ (instancetype)imageRepWithContentsOfFile:(NSString *)filename;
+ (instancetype)imageRepWithContentsOfURL:(NSURL *)url;
+ (instancetype)imageRepWithSVGImage:(SVGKImage*)theImage;
+ (instancetype)imageRepWithSVGSource:(SVGKSource*)theSource;

- (id)initWithData:(NSData *)theData;
- (id)initWithContentsOfURL:(NSURL *)theURL;
- (id)initWithContentsOfFile:(NSString *)thePath;
- (id)initWithSVGString:(NSString *)theString;
- (id)initWithSVGImage:(SVGKImage*)theImage;
- (id)initWithSVGSource:(SVGKSource*)theSource;

- (NSData *)TIFFRepresentation;
- (NSData *)TIFFRepresentationWithSize:(NSSize)theSize;
- (NSData *)TIFFRepresentationUsingCompression:(NSTIFFCompression)comp factor:(float)factor;
- (NSData *)TIFFRepresentationUsingCompression:(NSTIFFCompression)comp factor:(float)factor size:(NSSize)asize;

+ (void)loadSVGKImageRep;
+ (void)unloadSVGKImageRep;


@end

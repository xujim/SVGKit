//
//  SVGKImageRep.m
//  SVGKit-OSX
//
//  Created by C.W. Betts on 11/21/13.
//  Copyright (c) 2013 C.W. Betts. All rights reserved.
//

#import "SVGKImageRep.h"

#import "SVGKit.h"
#import "SVGKImage.h"
#import "SVGKSourceString.h"
#import "SVGKSourceLocalFile.h"
#import "SVGKSourceURL.h"

@interface SVGKImage (PrivateAPI)
-(void) renderToContext:(CGContextRef) context antiAliased:(BOOL) shouldAntialias curveFlatnessFactor:(CGFloat) multiplyFlatness interpolationQuality:(CGInterpolationQuality) interpolationQuality flipYaxis:(BOOL) flipYaxis;

@end

@interface SVGKImageRep ()
@property (nonatomic, retain, readwrite, setter = setTheSVG:) SVGKImage *image;
@property BOOL antiAlias;
@property CGFloat curveFlatness;
@property CGInterpolationQuality interpolationQuality;
@end


@implementation SVGKImageRep
@synthesize curveFlatness = _curveFlatness;
@synthesize antiAlias = _antiAlias;
@synthesize interpolationQuality = _interpolQuality;

- (NSData *)TIFFRepresentationWithSize:(NSSize)theSize
{
	self.image.size = theSize;
	return [self.image.imageRep TIFFRepresentation];
}

- (NSData *)TIFFRepresentation
{
	return [self TIFFRepresentationWithSize:self.size];
}

- (NSData *)TIFFRepresentationUsingCompression:(NSTIFFCompression)comp factor:(float)factor
{
	return [self TIFFRepresentationUsingCompression:comp factor:factor size:self.size];
}

- (NSData *)TIFFRepresentationUsingCompression:(NSTIFFCompression)comp factor:(float)factor size:(NSSize)asize
{
	self.image.size = asize;
	return [self.image.imageRep TIFFRepresentationUsingCompression:comp factor:factor];
}

+ (NSArray *)imageUnfilteredFileTypes
{
	static NSArray *types = nil;
	if (types == nil) {
		types = [[NSArray alloc] initWithObjects:@"svg", nil];
	}
	return types;
}

+ (NSArray *)imageUnfilteredTypes
{
	static NSArray *UTItypes = nil;
	if (UTItypes == nil) {
		UTItypes = [[NSArray alloc] initWithObjects:@"public.svg-image", nil];
	}
	return UTItypes;
}

+ (NSArray *)imageUnfilteredPasteboardTypes
{
	/* TODO */
	return nil;
}

+ (BOOL)canInitWithData:(NSData *)d
{
	SVGKParseResult *parseResult = nil;
	@autoreleasepool {
		parseResult = [[SVGKParser parseSourceUsingDefaultSVGKParser:[[[SVGKSource alloc] initWithInputSteam:[NSInputStream inputStreamWithData:d]] autorelease]] retain];
	}
	if (parseResult == nil) {
		return NO;
	}
	if (!parseResult.parsedDocument) {
		[parseResult release];
		return NO;
	}
	[parseResult release];
	return YES;
}

- (void)setSize:(NSSize)aSize sizeImage:(BOOL)theSize
{
	[super setSize:aSize];
	[self setPixelsHigh:ceil(aSize.height)];
	[self setPixelsWide:ceil(aSize.width)];
	if (theSize) {
		self.image.size = aSize;
	}
}

- (void)setSize:(NSSize)aSize
{
	[self setSize:aSize sizeImage:YES];
}

- (void)dealloc
{
	self.image = nil;
	
	[super dealloc];
}

+ (void)loadSVGKImageRep
{
	[NSImageRep registerImageRepClass:[SVGKImageRep class]];
}

+ (void)unloadSVGKImageRep
{
	[NSImageRep unregisterImageRepClass:[SVGKImageRep class]];
}

+ (void)load
{
	[self loadSVGKImageRep];
}

+ (instancetype)imageRepWithData:(NSData *)d
{
	return [[[self alloc] initWithData:d] autorelease];
}

+ (instancetype)imageRepWithContentsOfFile:(NSString *)filename
{
	return [[[self alloc] initWithContentsOfFile:filename] autorelease];
}

+ (instancetype)imageRepWithContentsOfURL:(NSURL *)url
{
	return [[[self alloc] initWithContentsOfURL:url] autorelease];
}

+ (instancetype)imageRepWithSVGSource:(SVGKSource*)theSource
{
	return [[[self alloc] initWithSVGSource:theSource] autorelease];
}

+ (instancetype)imageRepWithSVGImage:(SVGKImage*)theImage
{
	return [[[self alloc] initWithSVGImage:theImage] autorelease];
}

- (id)initWithData:(NSData *)theData
{
	return [self initWithSVGImage:[SVGKImage imageWithData:theData]];
}

- (id)initWithContentsOfURL:(NSURL *)theURL
{
	return [self initWithSVGImage:[SVGKImage imageWithContentsOfURL:theURL]];
}

- (id)initWithContentsOfFile:(NSString *)thePath
{
	return [self initWithSVGImage:[SVGKImage imageWithContentsOfFile:thePath]];
}

- (id)initWithSVGString:(NSString *)theString
{
	return [self initWithSVGSource:[SVGKSourceString sourceFromContentsOfString:theString]];
}

- (id)initWithSVGSource:(SVGKSource*)theSource
{
	return [self initWithSVGImage:[SVGKImage imageWithSource:theSource]];
}

- (id)initWithSVGImage:(SVGKImage*)theImage
{
	if (self = [super init]) {
		if (theImage == nil) {
			[self autorelease];
			return nil;
		}
		
		self.image = theImage;
		
#if 0
		BOOL hasGrad = ![SVGKFastImageView svgImageHasNoGradients:self.image];
		BOOL hasText = ![SVGKFastImageView svgImageHasNoText:self.image];
		
		if (hasGrad || hasText) {
			NSString *errstuff = nil;
			
			if (hasGrad) {
				errstuff = @"gradients";
				if (hasText) {
					errstuff = [errstuff stringByAppendingString:@" and text"];
				}
			} else if (hasText) {
				errstuff = @"text";
			}
			
			if (errstuff == nil) {
				//We shouldn't get here!
				errstuff = @"";
			}
			
			DDLogWarn(@"[%@] The image \"%@\" might have problems rendering correctly due to %@.", [self class], [self image], errstuff);
		}
#endif
		if (![self.image hasSize]) {
			self.image.size = CGSizeMake(32, 32);
		}
		
		[self setColorSpaceName:NSCalibratedRGBColorSpace];
		[self setAlpha:YES];
		[self setBitsPerSample:0];
		[self setOpaque:NO];
		[self setSize:self.image.size sizeImage:NO];
		self.interpolationQuality = kCGInterpolationDefault;
		self.antiAlias = YES;
		self.curveFlatness = 1.0;
	}
	return self;
}

- (BOOL)drawInRect:(NSRect)rect
{
	NSSize scaledSize = rect.size;
	if (!CGSizeEqualToSize(self.image.size, scaledSize)) {
		//For when we're at the full size.
		if (CGSizeEqualToSize(CGSizeMake(self.pixelsWide, self.pixelsHigh), scaledSize)) {
			return [super drawInRect:rect];
		} else {
			[self.image scaleToFitInside:scaledSize];
		}
	} else if (CGSizeEqualToSize(CGSizeMake(self.pixelsWide, self.pixelsHigh), scaledSize) &&
			   CGSizeEqualToSize(self.image.size, CGSizeMake(self.pixelsWide, self.pixelsHigh))) {
		return [super drawInRect:rect];
	}
#if CHECKFORRENDERINCONTEXT
	if ([self.image respondsToSelector:@selector(renderToContext:antiAliased:curveFlatnessFactor:interpolationQuality:flipYaxis:)]) {
#endif
		//We'll use this because it's probably faster, and we're drawing almost directly to the graphics context...
		CGContextRef imRepCtx = [[NSGraphicsContext currentContext] graphicsPort];
		CGLayerRef layerRef = CGLayerCreateWithContext(imRepCtx, rect.size, NULL);
		if (!layerRef) {
			return NO;
		}
		
		CGContextRef layerCont = CGLayerGetContext(layerRef);
		CGContextSaveGState(layerCont);
		[self.image renderToContext:layerCont antiAliased:_antiAlias curveFlatnessFactor:_curveFlatness interpolationQuality:_interpolQuality flipYaxis:YES];
		CGContextRestoreGState(layerCont);
		
		CGContextDrawLayerInRect(imRepCtx, rect, layerRef);
		CGLayerRelease(layerRef);
#if CHECKFORRENDERINCONTEXT
	} else {
		//...But should the method be removed in a future version, fall back to the old method
		NSImage *tmpImage = [[NSImage alloc] initWithSize:scaledSize];
		if (!tmpImage) {
			return NO;
		}
		
		NSBitmapImageRep *bitRep = [self.image exportBitmapImageRepAntiAliased:_antiAlias curveFlatnessFactor:_curveFlatness interpolationQuality:_interpolQuality showInfo:NO];
		if (!bitRep) {
			[tmpImage release];
			return NO;
		}
		[tmpImage addRepresentation:bitRep];
		
		NSRect imageRect;
		imageRect.size = rect.size;
		imageRect.origin = NSZeroPoint;
		
		[tmpImage drawAtPoint:rect.origin fromRect:imageRect operation:NSCompositeSourceOver fraction:1];
		[tmpImage release];
	}
#endif
	
	return YES;
}

- (BOOL)draw
{
	//Just in case someone resized the image rep.
	NSSize scaledSize = self.size;
	if (!CGSizeEqualToSize(self.image.size, scaledSize)) {
		self.image.size = scaledSize;
	}
#if CHECKFORRENDERINCONTEXT
	if ([self.image respondsToSelector:@selector(renderToContext:antiAliased:curveFlatnessFactor:interpolationQuality:flipYaxis:)]) {
#endif
		//We'll use this because it's probably faster, and we're drawing almost directly to the graphics context...
		CGContextRef imRepCtx = [[NSGraphicsContext currentContext] graphicsPort];
		CGLayerRef layerRef = CGLayerCreateWithContext(imRepCtx, scaledSize, NULL);
		if (!layerRef) {
			return NO;
		}
		
		CGContextRef layerCont = CGLayerGetContext(layerRef);
		CGContextSaveGState(layerCont);
		[self.image renderToContext:layerCont antiAliased:_antiAlias curveFlatnessFactor:_curveFlatness interpolationQuality:_interpolQuality flipYaxis:YES];
		CGContextRestoreGState(layerCont);
		
		CGContextDrawLayerAtPoint(imRepCtx, CGPointZero, layerRef);
		CGLayerRelease(layerRef);
#if CHECKFORRENDERINCONTEXT
	} else {
		//...But should the method be removed in a future version, fall back to the old method
		NSImage *tmpImage = [[NSImage alloc] initWithSize:scaledSize];
		if (!tmpImage) {
			return NO;
		}
		
		NSBitmapImageRep *bitRep = [self.image exportBitmapImageRepAntiAliased:_antiAlias curveFlatnessFactor:_curveFlatness interpolationQuality:_interpolQuality showInfo:NO];
		if (!bitRep) {
			[tmpImage release];
			return NO;
		}
		[tmpImage addRepresentation:bitRep];
		
		NSRect imageRect;
		imageRect.size = self.size;
		imageRect.origin = NSZeroPoint;
		
		[tmpImage drawAtPoint:NSZeroPoint fromRect:imageRect operation:NSCompositeSourceOver fraction:1];
		[tmpImage release];
	}
#endif
	
	return YES;
}


@end

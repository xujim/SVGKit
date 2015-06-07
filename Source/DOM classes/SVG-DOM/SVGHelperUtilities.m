#import "SVGHelperUtilities.h"

#import "CAShapeLayerWithHitTest.h"
#import "SVGUtils.h"
#import "SVGGradientElement.h"
#import "CGPathAdditions.h"

#import "SVGTransformable.h"
#import "SVGSVGElement.h"
#import "SVGGradientLayer.h"

#import "SVGKCGFloatAdditions.h"

@implementation SVGHelperUtilities


+(CGAffineTransform) transformRelativeIncludingViewportForTransformableOrViewportEstablishingElement:(SVGElement*) transformableOrSVGSVGElement
{
	NSAssert([transformableOrSVGSVGElement conformsToProtocol:@protocol(SVGTransformable)] || [transformableOrSVGSVGElement isKindOfClass:[SVGSVGElement class]], @"Illegal argument, sent a non-SVGTransformable, non-SVGSVGElement object to a method that requires an SVGTransformable (NB: Apple's Xcode is rubbish, it should have thrown a compiler error that you even tried to do this, but it often doesn't bother). Incoming instance = %@", transformableOrSVGSVGElement );
	
	/**
	 Each time you hit a viewPortElement in the DOM Tree, you
	 have to insert an ADDITIONAL transform into the flow of:
	 
	 parent-transform -> child-transform
	 
	 has to become:
	 
	 parent-transform -> VIEWPORT-TRANSFORM -> child-transform
	 */
	
	CGAffineTransform currentRelativeTransform;
	CGAffineTransform optionalViewportTransform;
	
	/**
	 Current relative transform: for an incoming "SVGTransformable" it's .transform, for everything else its identity
	 */
	if( [transformableOrSVGSVGElement conformsToProtocol:@protocol(SVGTransformable)])
	{
		currentRelativeTransform = ((SVGElement<SVGTransformable>*)transformableOrSVGSVGElement).transform;
	}
	else
	{
		currentRelativeTransform = CGAffineTransformIdentity;
	}
	
	/**
	 Optional relative transform: if incoming element establishes a viewport, do something clever; for everything else, use identity
	 */
	if( transformableOrSVGSVGElement.viewportElement == nil // if it's nil, it means THE OPPOSITE of what you'd expect - it means that it IS the viewport element - SVG Spec REQUIRES this
	   || transformableOrSVGSVGElement.viewportElement == transformableOrSVGSVGElement // ?? I don't understand: ?? if it's something other than itself, then: we simply don't need to worry about it ??
	   )
	{
		SVGSVGElement<SVGFitToViewBox>* svgSVGElement = (SVGSVGElement<SVGFitToViewBox>*) transformableOrSVGSVGElement;
		
		/**
		 Calculate the "implicit" viewport->viewbox transform (caused by the <SVG> tag's possible "viewBox" attribute)
		 Also calculate the "implicit" realViewport -> svgDefaultViewport transform (caused by the user changing the external
		 size of the rendered SVG)
		 */
		SVGRect frameViewBox = svgSVGElement.viewBox; // the ACTUAL viewbox (may be Uninitalized if none specified in SVG file)
		SVGRect frameActualViewport = svgSVGElement.viewport; // the ACTUAL viewport (dictated by the graphics engine; may be Uninitialized if the renderer has too little info to decide on a viewport at all!)
		SVGRect frameRequestedViewport = svgSVGElement.requestedViewport; // the default viewport requested in the SVG source file (may be Uninitialized if no svg width or height params in original source file)
		
		if( ! SVGRectIsInitialized(frameActualViewport))
		{
			/** We have NO VIEWPORT (renderer was presented too little info)
			 
			 Net effect: we MUST render everything at 1:1, and apply NO FURTHER TRANSFORMS
			 */
			optionalViewportTransform = CGAffineTransformIdentity;
		}
		else
		{
			CGAffineTransform transformRealViewportToSVGViewport;
			CGAffineTransform transformSVGViewportToSVGViewBox;
			
			/** Transform part 1: from REAL viewport to EXPECTED viewport */
			SVGRect viewportForViewBoxToRelateTo;
			if( SVGRectIsInitialized( frameRequestedViewport ))
			{
				viewportForViewBoxToRelateTo = frameRequestedViewport;
				transformRealViewportToSVGViewport = CGAffineTransformMakeScale( frameActualViewport.width / frameRequestedViewport.width, frameActualViewport.height / frameRequestedViewport.height);
			}
			else
			{
				viewportForViewBoxToRelateTo = frameActualViewport;
				transformRealViewportToSVGViewport = CGAffineTransformIdentity;
			}
			
			/** Transform part 2: from EXPECTED viewport to internal viewBox */
			if( SVGRectIsInitialized( frameViewBox ) )
			{
				CGAffineTransform translateToViewBox = CGAffineTransformMakeTranslation( -frameViewBox.x, -frameViewBox.y );
				CGAffineTransform scaleToViewBox = CGAffineTransformMakeScale( viewportForViewBoxToRelateTo.width / frameViewBox.width, viewportForViewBoxToRelateTo.height / frameViewBox.height);
				
				/** This is hard to find in the spec, but: if you have NO implementation of PreserveAspectRatio, you still need to
				 read the spec on PreserveAspectRatio - because it defines a default behaviour for files that DO NOT specify it,
				 which is different from the mathemetic default of co-ordinate systems.
				 
				 In short, you MUST implement "<svg preserveAspectRatio=xMidYMid ... />", even if you're not supporting that attribute.
				 */
				if( svgSVGElement.preserveAspectRatio.baseVal.meetOrSlice == SVG_MEETORSLICE_MEET ) // ALWAYS TRUE in current implementation
				{
					if( ABS( svgSVGElement.aspectRatioFromWidthPerHeight - svgSVGElement.aspectRatioFromViewBox) > 0.00001 )
					{
						/** The aspect ratios for viewport and viewbox differ; Spec requires us to
						 insert an extra transform that causes aspect ratio for internal data to be
						 
						 ... MEET:  == KEPT CONSTANT
						 
						 and to "aspect-scale to fit" (i.e. leaving letterboxes at topbottom / leftright as required)
						 
						 c.f.: http://www.w3.org/TR/SVG/coords.html#PreserveAspectRatioAttribute (read carefully)
						 */
						
						double ratioOfRatios = svgSVGElement.aspectRatioFromWidthPerHeight / svgSVGElement.aspectRatioFromViewBox;
						
						DDLogWarn(@"ratioOfRatios = %.2f", ratioOfRatios );
						DDLogWarn(@"Experimental: auto-scaling viewbox transform to fulfil SVG spec's default MEET settings, because your SVG file has different aspect-ratios for viewBox and for svg.width,svg.height");
						
						/**
						 For MEET, we have to SHRINK the viewbox's contents if they aren't as wide:high as the viewport:
						 */
						CGAffineTransform catRestoreAspectRatio;
						if( ratioOfRatios > 1 )
							catRestoreAspectRatio = CGAffineTransformMakeScale( 1.0 / ratioOfRatios, 1.0 );
						else
							catRestoreAspectRatio = CGAffineTransformMakeScale( 1.0, 1.0 * ratioOfRatios );
						
						double xTranslationRequired;
						double yTranslationRequired;
						if( ratioOfRatios > 1.0 ) // if we're going to have space to either side
						{
							switch( svgSVGElement.preserveAspectRatio.baseVal.align )
							{
								case SVG_PRESERVEASPECTRATIO_XMINYMIN:
								case SVG_PRESERVEASPECTRATIO_XMINYMID:
								case SVG_PRESERVEASPECTRATIO_XMINYMAX:
								{
									xTranslationRequired = 0.0;
								}break;
									
								case SVG_PRESERVEASPECTRATIO_XMIDYMIN:
								case SVG_PRESERVEASPECTRATIO_XMIDYMID:
								case SVG_PRESERVEASPECTRATIO_XMIDYMAX:
								{
									xTranslationRequired = ((ratioOfRatios-1.0)/2.0) * frameViewBox.width;
								}break;
									
								case SVG_PRESERVEASPECTRATIO_XMAXYMIN:
								case SVG_PRESERVEASPECTRATIO_XMAXYMID:
								case SVG_PRESERVEASPECTRATIO_XMAXYMAX:
								{
									xTranslationRequired = ((ratioOfRatios-1.0) * frameViewBox.width);
								}break;
									
								case SVG_PRESERVEASPECTRATIO_NONE:
								case SVG_PRESERVEASPECTRATIO_UNKNOWN:
								{
									xTranslationRequired = 0;
								}break;
							}
						}
						else
							xTranslationRequired = 0;
						
						if( ratioOfRatios < 1.0 ) // if we're going to have space above and below
						{
							switch( svgSVGElement.preserveAspectRatio.baseVal.align )
							{
								case SVG_PRESERVEASPECTRATIO_XMINYMIN:
								case SVG_PRESERVEASPECTRATIO_XMIDYMIN:
								case SVG_PRESERVEASPECTRATIO_XMAXYMIN:
								{
									yTranslationRequired = 0.0;
								}break;
									
								case SVG_PRESERVEASPECTRATIO_XMINYMID:
								case SVG_PRESERVEASPECTRATIO_XMIDYMID:
								case SVG_PRESERVEASPECTRATIO_XMAXYMID:
								{
									yTranslationRequired = ((1.0-ratioOfRatios)/2.0 * [svgSVGElement.height pixelsValue]);
								}break;
									
								case SVG_PRESERVEASPECTRATIO_XMINYMAX:
								case SVG_PRESERVEASPECTRATIO_XMIDYMAX:
								case SVG_PRESERVEASPECTRATIO_XMAXYMAX:
								{
									yTranslationRequired = ((1.0-ratioOfRatios) * [svgSVGElement.height pixelsValue]);
								}break;
									
								case SVG_PRESERVEASPECTRATIO_NONE:
								case SVG_PRESERVEASPECTRATIO_UNKNOWN:
								{
									yTranslationRequired = 0.0;
								}break;
							}
						}
						else
							yTranslationRequired = 0.0;
						/**
						 For xMidYMid, we have to RE-CENTER the viewbox's contents if they aren't as wide:high as the viewport:
						 */
						CGAffineTransform catRecenterNewAspectRatio = CGAffineTransformMakeTranslation( xTranslationRequired, yTranslationRequired );
						
						CGAffineTransform transformsThatHonourAspectRatioRequirements = CGAffineTransformConcat(catRecenterNewAspectRatio, catRestoreAspectRatio);
						
						scaleToViewBox = CGAffineTransformConcat( transformsThatHonourAspectRatioRequirements, scaleToViewBox );
					}
				}	
				else
					DDLogWarn( @"Unsupported: preserveAspectRatio set to SLICE. Code to handle this doesn't exist yet.");
				
				transformSVGViewportToSVGViewBox = CGAffineTransformConcat( translateToViewBox, scaleToViewBox );
			}
			else
				transformSVGViewportToSVGViewBox = CGAffineTransformIdentity;
			
			optionalViewportTransform = CGAffineTransformConcat( transformRealViewportToSVGViewport, transformSVGViewportToSVGViewBox );
		}
	}
	else
	{
		optionalViewportTransform = CGAffineTransformIdentity;
	}
	
	/**
	 TOTAL relative based on the local "transform" property and the viewport (if present)
	 */
	CGAffineTransform result = CGAffineTransformConcat( currentRelativeTransform, optionalViewportTransform);
	
	return result;
}

/*!
 Re-calculates the absolute transform on-demand by querying parent's absolute transform and appending self's relative transform.
 
 Can take ONLY TWO kinds of element:
  - something that implements SVGTransformable (non-transformables shouldn't be performing transforms!)
  - something that defines a new viewport co-ordinate system (i.e. the SVG tag itself; this is AN IMPLICIT TRANSFORMABLE!)
 */
+(CGAffineTransform) transformAbsoluteIncludingViewportForTransformableOrViewportEstablishingElement:(SVGElement*) transformableOrSVGSVGElement
{
	NSAssert([transformableOrSVGSVGElement conformsToProtocol:@protocol(SVGTransformable)] || [transformableOrSVGSVGElement isKindOfClass:[SVGSVGElement class]], @"Illegal argument, sent a non-SVGTransformable, non-SVGSVGElement object to a method that requires an SVGTransformable (NB: Apple's Xcode is rubbish, it should have thrown a compiler error that you even tried to do this, but it often doesn't bother). Incoming instance = %@", transformableOrSVGSVGElement );
	
	CGAffineTransform parentAbsoluteTransform = CGAffineTransformIdentity;
	
	NSAssert( transformableOrSVGSVGElement.parentNode == nil || [transformableOrSVGSVGElement.parentNode isKindOfClass:[SVGElement class]], @"I don't know what to do when parent node is NOT an SVG element of some kind; presumably, this is when SVG root node gets embedded inside something else? The Spec IS UNCLEAR and doesn't clearly define ANYTHING here, and provides very few examples" );
	
	/**
	 Parent Absolute transform: one of the following
	 
	 a. parent is an SVGTransformable (so recurse this method call to find it)
	 b. parent is a viewport-generating element (so recurse this method call to find it)
	 c. parent is nil (so treat it as Identity)
	 d. parent is something else (so do a while loop until we hit an a, b, or c above)
	 */
	SVGElement* parentSVGElement = transformableOrSVGSVGElement;
	while( (parentSVGElement = (SVGElement*) parentSVGElement.parentNode) != nil )
	{
		if( [parentSVGElement conformsToProtocol:@protocol(SVGTransformable)] )
		{
			parentAbsoluteTransform = [self transformAbsoluteIncludingViewportForTransformableOrViewportEstablishingElement:parentSVGElement];
			break;
		}
		
		if( [parentSVGElement isKindOfClass:[SVGSVGElement class]] )
		{
			parentAbsoluteTransform = [self transformAbsoluteIncludingViewportForTransformableOrViewportEstablishingElement:parentSVGElement];
			break;
		}
	}
	
	/**
	 TOTAL absolute based on the parent transform with relative (and possible viewport) transforms
	 */
	CGAffineTransform result = CGAffineTransformConcat( [self transformRelativeIncludingViewportForTransformableOrViewportEstablishingElement:transformableOrSVGSVGElement], parentAbsoluteTransform );
	
	//DEBUG: DDLogWarn( @"[%@] self.transformAbsolute: returning: affine( (%2.2f %2.2f %2.2f %2.2f), (%2.2f %2.2f)", [self class], result.a, result.b, result.c, result.d, result.tx, result.ty);
	
	return result;
}

+(void) configureCALayer:(CALayer*) layer usingElement:(SVGElement*) nonStylableElement
{
	layer.name = nonStylableElement.identifier;
	[layer setValue:nonStylableElement.identifier forKey:kSVGElementIdentifier];
	
#if FORCE_RASTERIZE_LAYERS
	if ([layer respondsToSelector:@selector(setShouldRasterize:)]) {
		[layer performSelector:@selector(setShouldRasterize:)
						  withObject:@YES];
	}
	
	/** If you're going to rasterize, Apple's code is dumb, and needs to be "told" if its using a Retina display */
	layer.contentsScale = [[UIScreen mainScreen] scale];
	layer.rasterizationScale = _shapeLayer.contentsScale;
#endif
	
	if( [nonStylableElement conformsToProtocol:@protocol(SVGStylable)])
	{
		SVGElement<SVGStylable>* stylableElement = (SVGElement<SVGStylable>*) nonStylableElement;
		
		NSString* actualOpacity = [stylableElement cascadedValueForStylableProperty:@"opacity" inherit:NO];
		layer.opacity = actualOpacity.length > 0 ? [actualOpacity SVGKCGFloatValue] : 1.0; // svg's "opacity" defaults to 1!
		
        // Apply fill-rule on layer (only CAShapeLayer)
        NSString *fillRule = [stylableElement cascadedValueForStylableProperty:@"fill-rule"];
        if([fillRule isEqualToString:@"evenodd"] && [layer isKindOfClass:[CAShapeLayer class]]){
            CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
            shapeLayer.fillRule = @"even-odd";
        }
	}
}

+(CALayer *) newCALayerForPathBasedSVGElement:(SVGElement<SVGTransformable>*) svgElement withPath:(CGPathRef) pathRelative
{
	CAShapeLayer* _shapeLayer = [CAShapeLayerWithHitTest layer];
	
	[self configureCALayer:_shapeLayer usingElement:svgElement];
	
	NSString* actualStroke = [svgElement cascadedValueForStylableProperty:@"stroke"];
	if (!actualStroke)
		actualStroke = @"none";
	NSString* actualStrokeWidth = [svgElement cascadedValueForStylableProperty:@"stroke-width"];
	
	CGFloat strokeWidth = 1.0;
	
	if (actualStrokeWidth)
	{
		SVGRect r = ((SVGSVGElement*) svgElement.viewportElement).viewport;
		
		strokeWidth = [[SVGLength svgLengthFromNSString:actualStrokeWidth]
					   pixelsValueWithDimension: hypot(r.width, r.height)];
	}
	
	/** transform our LOCAL path into ABSOLUTE space */
	CGAffineTransform transformAbsolute = [self transformAbsoluteIncludingViewportForTransformableOrViewportEstablishingElement:svgElement];

	// calculate the rendered dimensions of the path
	CGRect r = CGRectInset(CGPathGetBoundingBox(pathRelative), -strokeWidth/2., -strokeWidth/2.);
	CGRect transformedPathBB = CGRectApplyAffineTransform(r, transformAbsolute);
	
	CGPathRef pathToPlaceInLayer = CGPathCreateCopyByTransformingPath(pathRelative, &transformAbsolute);
	
	/** find out the ABSOLUTE BOUNDING BOX of our transformed path */
	//DEBUG ONLY: CGRect unTransformedPathBB = CGPathGetBoundingBox( _pathRelative );

#if IMPROVE_PERFORMANCE_BY_WORKING_AROUND_APPLE_FRAME_ALIGNMENT_BUG
	transformedPathBB = CGRectIntegral( transformedPathBB ); // ridiculous but improves performance of apple's code by up to 50% !
#endif

	/** NB: when we set the _shapeLayer.frame, it has a *side effect* of moving the path itself - so, in order to prevent that,
	 because Apple didn't provide a BOOL to disable that "feature", we have to pre-shift the path forwards by the amount it
	 will be shifted backwards */
	CGPathRef finalPath = CGPathCreateByOffsettingPath( pathToPlaceInLayer, transformedPathBB.origin.x, transformedPathBB.origin.y );
	
	/** Can't use this - iOS 5 only! path = CGPathCreateCopyByTransformingPath(path, transformFromSVGUnitsToScreenUnits ); */
	
	_shapeLayer.path = finalPath;
	CGPathRelease(finalPath);
	
	/**
	 NB: this line, by changing the FRAME of the layer, has the side effect of also changing the CGPATH's position in absolute
	 space! This is why we needed the "CGPathRef finalPath =" line a few lines above...
	 */
	_shapeLayer.frame = transformedPathBB;
	
	CGRect localRect =  CGRectMake(0, 0, CGRectGetWidth(transformedPathBB), CGRectGetHeight(transformedPathBB));

	//DEBUG ONLY: CGRect shapeLayerFrame = _shapeLayer.frame;
	CAShapeLayer* strokeLayer = _shapeLayer;
	CAShapeLayer* fillLayer = _shapeLayer;
	
	if( strokeWidth > 0
	   && (! [@"none" isEqualToString:actualStroke]) )
	{
		/*
		 We have to apply any scale-factor part of the affine transform to the stroke itself (this is bizarre and horrible, yes, but that's the spec for you!)
		 */
		CGSize fakeSize = CGSizeMake( strokeWidth, strokeWidth );
		fakeSize = CGSizeApplyAffineTransform( fakeSize, transformAbsolute );
		strokeLayer.lineWidth = hypot(fakeSize.width, fakeSize.height)/M_SQRT2;
		
		SVGColor strokeColorAsSVGColor = SVGColorFromString([actualStroke UTF8String]); // have to use the intermediate of an SVGColor so that we can over-ride the ALPHA component in next line
		NSString* actualStrokeOpacity = [svgElement cascadedValueForStylableProperty:@"stroke-opacity"];
		if( actualStrokeOpacity.length > 0 )
			strokeColorAsSVGColor.a = (uint8_t) ([actualStrokeOpacity SVGKCGFloatValue] * 0xFF);
		
		strokeLayer.strokeColor = CGColorWithSVGColor( strokeColorAsSVGColor );
		
        /**
         Stroke dash array
         */
        NSString *dashArrayString = [svgElement cascadedValueForStylableProperty:@"stroke-dasharray"];
        if(dashArrayString != nil && ![dashArrayString isEqualToString:@""]) {
            NSArray *dashArrayStringComponents = [dashArrayString componentsSeparatedByString:@" "];
            if( [dashArrayStringComponents count] < 2 )
            { // min 2 elements required, perhaps it's comma-separated:
                dashArrayStringComponents = [dashArrayString componentsSeparatedByString:@","];
            }
            if( [dashArrayStringComponents count] > 1 )
            {
                BOOL valid = NO;
                NSMutableArray *dashArray = [NSMutableArray array];
                for( NSString *n in dashArrayStringComponents ){
                    [dashArray addObject:@([n floatValue])];
                    if( !valid && [n floatValue] != 0 ){
                        // avoid 'CGContextSetLineDash: invalid dash array: at least one element must be non-zero.'
                        valid = YES;
                    }
                }
                if( valid ){
                    strokeLayer.lineDashPattern = dashArray;
                }
            }
        }
		
		/**
		 Line joins + caps: butt / square / miter
		 */
		NSString* actualLineCap = [svgElement cascadedValueForStylableProperty:@"stroke-linecap"];
		NSString* actualLineJoin = [svgElement cascadedValueForStylableProperty:@"stroke-linejoin"];
		NSString* actualMiterLimit = [svgElement cascadedValueForStylableProperty:@"stroke-miterlimit"];
		if( actualLineCap.length > 0 )
		{
			if( [actualLineCap isEqualToString:@"butt"] )
				strokeLayer.lineCap = kCALineCapButt;
			else if( [actualLineCap isEqualToString:@"round"] )
				strokeLayer.lineCap = kCALineCapRound;
			else if( [actualLineCap isEqualToString:@"square"] )
				strokeLayer.lineCap = kCALineCapSquare;
		}
		if( actualLineJoin.length > 0 )
		{
			if( [actualLineJoin isEqualToString:@"miter"] )
				strokeLayer.lineJoin = kCALineJoinMiter;
			else if( [actualLineJoin isEqualToString:@"round"] )
				strokeLayer.lineJoin = kCALineJoinRound;
			else if( [actualLineJoin isEqualToString:@"bevel"] )
				strokeLayer.lineJoin = kCALineJoinBevel;
		}
		if( actualMiterLimit.length > 0 )
		{
			strokeLayer.miterLimit = [actualMiterLimit SVGKCGFloatValue];
		}
		if ( [actualStroke hasPrefix:@"url"] )
		{
			// need a new fill layer because the stroke layer is becoming a mask
			fillLayer = [CAShapeLayerWithHitTest layer];
			fillLayer.frame = strokeLayer.frame;
			fillLayer.opacity = strokeLayer.opacity;
			fillLayer.path = strokeLayer.path;
			
			NSRange idKeyRange = NSMakeRange(5, actualStroke.length - 6);
			NSString* strokeId = [actualStroke substringWithRange:idKeyRange];

			SVGGradientLayer *gradientLayer = [self getGradientLayerWithId:strokeId forElement:svgElement withRect:strokeLayer.frame
											   transform:transformAbsolute];
			
			strokeLayer.frame = localRect;

			strokeLayer.fillColor = nil;
			strokeLayer.strokeColor = [UIColor blackColor].CGColor;

			gradientLayer.mask = strokeLayer;
			strokeLayer = (CAShapeLayer*) gradientLayer;
		}
		
	}
	else
	{
		if( [@"none" isEqualToString:actualStroke] )
		{
			strokeLayer.strokeColor = nil; // This is how you tell Apple that the stroke is disabled; a strokewidth of 0 will NOT achieve this
			strokeLayer.lineWidth = 0.0f; // MUST set this explicitly, or Apple assumes 1.0
		}
		else
		{
			strokeLayer.lineWidth = 1.0f; // default value from SVG spec
		}
	}
	
	NSString* actualFill = [svgElement cascadedValueForStylableProperty:@"fill"];
	NSString* actualFillOpacity = [svgElement cascadedValueForStylableProperty:@"fill-opacity"];
	
	if ( [actualFill hasPrefix:@"url"] )
	{
		NSRange idKeyRange = NSMakeRange(5, actualFill.length - 6);
		NSString* fillId = [actualFill substringWithRange:idKeyRange];
		
		/** Replace the return layer with a special layer using the URL fill */
		/** fetch the fill layer by URL using the DOM */
		SVGGradientLayer *gradientLayer = [self getGradientLayerWithId:fillId forElement:svgElement withRect:fillLayer.frame
										   transform:transformAbsolute];
		
		CAShapeLayer* maskLayer = [CAShapeLayer layer];
		maskLayer.frame = localRect;
		maskLayer.path = fillLayer.path;
		maskLayer.fillColor = [UIColor blackColor].CGColor;
		maskLayer.strokeColor = nil;
		gradientLayer.mask = maskLayer;
		if ( [gradientLayer.type isEqualToString:kExt_CAGradientLayerRadial])
			gradientLayer.maskPath = fillLayer.path;
		gradientLayer.frame = fillLayer.frame;
		fillLayer = (CAShapeLayer* )gradientLayer;
	}
	else if( actualFill.length > 0 || actualFillOpacity.length > 0 )
	{
		fillLayer.fillColor = [self parseFillForElement:svgElement fromFill:actualFill andOpacity:actualFillOpacity];
	}
	CGPathRelease(pathToPlaceInLayer);
	
	NSString* actualOpacity = [svgElement cascadedValueForStylableProperty:@"opacity" inherit:NO];
	fillLayer.opacity = actualOpacity.length > 0 ? [actualOpacity floatValue] : 1; // unusually, the "opacity" attribute defaults to 1, not 0

	if (strokeLayer == fillLayer)
	{
		return strokeLayer;
	}
	CALayer* combined = [CALayer layer];
	
	combined.frame = strokeLayer.frame;
	strokeLayer.frame = localRect;
	if ([strokeLayer isKindOfClass:[CAShapeLayer class]])
		strokeLayer.fillColor = nil;
	fillLayer.frame = localRect;
	[combined addSublayer:fillLayer];
	[combined addSublayer:strokeLayer];
	return combined;
}

+ (SVGGradientLayer*)getGradientLayerWithId:(NSString*)gradId forElement:(SVGElement*)svgElement
								   withRect:(CGRect)r
								  transform:(CGAffineTransform)transform
{
	/** Replace the return layer with a special layer using the URL fill */
	/** fetch the fill layer by URL using the DOM */
	NSAssert( svgElement.rootOfCurrentDocumentFragment != nil, @"This SVG shape has a URL fill type; it needs to search for that URL (%@) inside its nearest-ancestor <SVG> node, but the rootOfCurrentDocumentFragment reference was nil (suggests the parser failed, or the SVG file is corrupt)", gradId );
	
	SVGGradientElement* svgGradient = (SVGGradientElement*) [svgElement.rootOfCurrentDocumentFragment getElementById:gradId];
	NSAssert( svgGradient != nil, @"This SVG shape has a URL fill (%@), but could not find an XML Node with that ID inside the DOM tree (suggests the parser failed, or the SVG file is corrupt)", gradId );

	[svgGradient synthesizeProperties];
	
	SVGGradientLayer *gradientLayer = [svgGradient newGradientLayerForObjectRect:r
																	viewportRect:svgElement.rootOfCurrentDocumentFragment.viewBox
																	   transform:transform];

	return gradientLayer;
}

+(CGColorRef) parseFillForElement:(SVGElement *)svgElement
{
	NSString* actualFill = [svgElement cascadedValueForStylableProperty:@"fill"];
	NSString* actualFillOpacity = [svgElement cascadedValueForStylableProperty:@"fill-opacity"];
	return [self parseFillForElement:svgElement fromFill:actualFill andOpacity:actualFillOpacity];
}

+(CGColorRef) parseFillForElement:(SVGElement *)svgElement fromFill:(NSString *)actualFill andOpacity:(NSString *)actualFillOpacity
{
	CGColorRef fillColor = nil;
	if ( [actualFill hasPrefix:@"none"])
	{
		fillColor = nil;
	}
	else if( actualFill.length > 0 || actualFillOpacity.length > 0 )
	{
		SVGColor fillColorAsSVGColor = ( actualFill.length > 0 ) ?
		SVGColorFromString([actualFill UTF8String]) // have to use the intermediate of an SVGColor so that we can over-ride the ALPHA component in next line
		: SVGColorMake(0, 0, 0, 0);
		
        if( actualFillOpacity.length > 0 )
            fillColorAsSVGColor.a = (uint8_t) ([actualFillOpacity floatValue] * 0xFF);
		
        fillColor = CGColorWithSVGColor(fillColorAsSVGColor);
	}
	else
	{
#if TARGET_OS_IPHONE
		fillColor = [UIColor blackColor].CGColor;
#else
		fillColor = CGColorGetConstantColor(kCGColorBlack);
#endif
	}

	return fillColor;
}

+(void) parsePreserveAspectRatioFor:(SVGKElement<SVGFitToViewBox>*) element
{
    element.preserveAspectRatio = [SVGAnimatedPreserveAspectRatio new]; // automatically sets defaults
    
    NSString* stringPreserveAspectRatio = @"";//[element getAttribute:@"preserveAspectRatio"];
    NSArray* aspectRatioCommands = [stringPreserveAspectRatio componentsSeparatedByString:@" "];
    
    for( NSString* aspectRatioCommand in aspectRatioCommands )
    {
        if( [aspectRatioCommand isEqualToString:@"meet"]) /** NB this is default anyway. Dont technically need to set it */
            element.preserveAspectRatio.baseVal.meetOrSlice = SVG_MEETORSLICE_MEET;
        else if( [aspectRatioCommand isEqualToString:@"slice"])
            element.preserveAspectRatio.baseVal.meetOrSlice = SVG_MEETORSLICE_SLICE;
        
        else if( [aspectRatioCommand isEqualToString:@"xMinYMin"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMINYMIN;
        else if( [aspectRatioCommand isEqualToString:@"xMinYMid"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMINYMID;
        else if( [aspectRatioCommand isEqualToString:@"xMinYMax"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMINYMAX;
        
        else if( [aspectRatioCommand isEqualToString:@"xMidYMin"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMIDYMIN;
        else if( [aspectRatioCommand isEqualToString:@"xMidYMid"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMIDYMID;
        else if( [aspectRatioCommand isEqualToString:@"xMidYMax"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMIDYMAX;
        
        else if( [aspectRatioCommand isEqualToString:@"xMaxYMin"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMAXYMIN;
        else if( [aspectRatioCommand isEqualToString:@"xMaxYMid"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMAXYMID;
        else if( [aspectRatioCommand isEqualToString:@"xMaxYMax"])
            element.preserveAspectRatio.baseVal.align = SVG_PRESERVEASPECTRATIO_XMAXYMAX;
        
        else
        {
            DDLogWarn(@"Found unexpected preserve-aspect-ratio command inside element's 'preserveAspectRatio' attribute. Command = '%@'", aspectRatioCommand );
        }
    }
}

@end

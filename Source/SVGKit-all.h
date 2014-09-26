//
//  SVGKit-all.h
//  SVGKit
//
//  Created by C.W. Betts on 9/26/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

#ifndef SVGKit_SVGKit_all_h
#define SVGKit_SVGKit_all_h

#import "SVGKit.h"
#import "CALayerExporter.h"
#import "CALayer+RecursiveClone.h"
#import "CALayerWithChildHitTest.h"
#import "CALayerWithClipRender.h"
#import "CAShapeLayerWithClipRender.h"
#import "CAShapeLayerWithHitTest.h"
#import "CSSPrimitiveValue.h"
#import "CSSPrimitiveValue_ConfigurablePixelsPerInch.h"
#import "CSSRuleList.h"
#import "CSSStyleRule.h"
#import "CSSStyleSheet.h"
#import "CSSValue_ForSubclasses.h"
#import "CSSValueList.h"
#import "DOMGlobalSettings.h"
#import "MediaList.h"
#import "NamedNodeMap_Iterable.h"
#import "StyleSheet.h"
#import "StyleSheetList.h"
#import "SVGElementInstance.h"
#import "SVGElementInstanceList.h"
#import "SVGGradientElement.h"
#import "SVGGradientLayer.h"
#import "SVGGradientStop.h"
#import "SVGGroupElement.h"
#import "SVGKExporterNSData.h"
#import "SVGKExporterUIImage.h"
#import "SVGHelperUtilities.h"
#import "SVGStyleCatcher.h"
#import "SVGStyleElement.h"

// Parser headers
#import "SVGKPointsAndPathsParser.h"
#import "SVGKParserDefsAndUse.h"
#import "SVGKParserDOM.h"
#import "SVGKParserGradient.h"
#import "SVGKParserPatternsAndGradients.h"
#import "SVGKParserStyles.h"

// Mutable headers
#import "Document+Mutable.h"
#import "CSSRuleList+Mutable.h"
#import "SVGSVGElement_Mutable.h"
#import "SVGUseElement_Mutable.h"
#import "SVGElementInstance_Mutable.h"
#import "SVGDocument_Mutable.h"
#import "NodeList+Mutable.h"

// Source headers
#import "SVGKSourceLocalFile.h"
#import "SVGKSourceNSData.h"
#import "SVGKSourceString.h"
#import "SVGKSourceURL.h"

#endif

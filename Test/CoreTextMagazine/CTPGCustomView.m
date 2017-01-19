//
//  CTPGCustomView.m
//  Test
//
//  Created by yubinqiang on 16/12/16.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGCustomView.h"
#import "CTPGPropertyWithParaphrase.h"
@implementation CTPGCustomView


- (void)drawRect:(CGRect)rect {
    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context coordinates, in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Initialize a string.
    CFStringRef propertyOfWord = CFSTR("propertyOfWord");
    CFStringRef textString = CFSTR("propertyOfWordparaphrase of Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    CFMutableAttributedStringRef mutableAttributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString(mutableAttributedString, CFRangeMake(0, 0), textString);
    // Create a color that will be added as an attribute to the attrString.
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { 0.0, 0.0, 1.0, 0.8 };
    CGColorRef blue = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    
    CFAttributedStringSetAttribute(mutableAttributedString,
                                   CFRangeMake(0, CFStringGetLength(propertyOfWord)),
                                   kCTForegroundColorAttributeName, blue);
    

    [self drawRect:self.bounds
             properties:self.propertyWithParaphrase.arrayOfProperty
            paraphrases:self.propertyWithParaphrase.arrayOfParaphrase
                context:context];
#if 0
    CGFloat maxWidthOfProperty = [self maxWidthInAttributedStrings:@[[[NSAttributedString alloc] initWithString:(__bridge NSString*)propertyOfWord]]
                                                        targetSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)
                                                          contenxt:NULL];
    CGFloat maxWidthOfPropertyIncludeGap = arc4random()%150 + maxWidthOfProperty;
    CGSize dimensionOfParaphrase = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                 CFRangeMake(CFStringGetLength(propertyOfWord), 0),
                                                 NULL,
                                                 CGSizeMake(CGRectGetWidth(self.bounds) - (maxWidthOfPropertyIncludeGap) , CGFLOAT_MAX),
                                                 NULL);
    KSLog(@"%s dimension:%@",__PRETTY_FUNCTION__, NSStringFromCGSize(dimensionOfParaphrase));
    
    CGRect rectOfParaphrase =  CGRectMake(maxWidthOfPropertyIncludeGap, 0, ceilf(dimensionOfParaphrase.width), ceilf(dimensionOfParaphrase.height));
    [self drawTextBounds:rectOfParaphrase context:context];
#endif

}

- (void)drawTextBounds:(CGRect)bounds context:(CGContextRef)context {
    CGRect rectInDeviceSpace = CGContextConvertRectToDeviceSpace(context, bounds);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rectOfText = CGRectApplyAffineTransform(rectInDeviceSpace, CGAffineTransformInvert(CGAffineTransformMakeScale(scale,scale)));
    
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathAddRect(mutablePath, NULL, rectOfText);
    CGContextAddPath(context, mutablePath);
    CGContextDrawPath(context, kCGPathStroke);
    CFRelease(mutablePath);
}

- (CGFloat)maxWidthInStrings:(NSArray<NSString *> *)arrayOfString {
    CGFloat maxWidth = 0;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    for (NSString *string in arrayOfString) {
        CGFloat width = ceilf([string boundingRectWithSize:targetSize
                                                   options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                attributes:NULL
                                                   context:NULL].size.width);
        maxWidth = width > maxWidth ? width : maxWidth;
    }
    return maxWidth;
}

- (void)drawRect:(CGRect)rect properties:(NSArray<NSString *> *)properties paraphrases:(NSArray<NSString *> *)paraphrases context:(CGContextRef)context {
    CGRect nextFrame = rect;
    const CGFloat maxWidthOfProperty = [self maxWidthInStrings:properties];
    assert(maxWidthOfProperty > 0);
    const CGFloat maxWidthOfPropertyIncludeGap = maxWidthOfProperty + 15;
    if (properties.count > paraphrases.count) {
        
    } else {
        for (NSUInteger index = 0; index < properties.count; index++) {
            NSMutableAttributedString *mutableAttributedStringOfProperty = [[NSMutableAttributedString alloc] initWithString:properties[index]
                                                                                                                  attributes:NULL];
            NSMutableAttributedString *mutableAttributedStringOfParaphrase = [[NSMutableAttributedString alloc] initWithString:paraphrases[index]
                                                                                                                  attributes:NULL];
            
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:mutableAttributedStringOfProperty];
            [mutableAttributedString appendAttributedString:mutableAttributedStringOfParaphrase];
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)mutableAttributedString);

            [self drawRect:CGRectMake(nextFrame.origin.x, nextFrame.origin.y,
                                      maxWidthOfProperty, CGRectGetHeight(nextFrame))
               framesetter:framesetter
               stringRange:CFRangeMake(0, mutableAttributedStringOfProperty.length)
                   context:context];
            
            
            [self drawRect:CGRectMake(maxWidthOfPropertyIncludeGap, nextFrame.origin.y,
                                      CGRectGetWidth(nextFrame) - maxWidthOfPropertyIncludeGap, CGRectGetHeight(nextFrame))
               framesetter:framesetter
               stringRange:CFRangeMake(mutableAttributedStringOfProperty.length, paraphrases[index].length)
                   context:context];
            
            CGSize dimension = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                            CFRangeMake(properties[index].length, 0),
                                                                            NULL,
                                                                            CGSizeMake(CGRectGetWidth(nextFrame) - maxWidthOfPropertyIncludeGap, CGRectGetHeight(self.bounds)),
                                                                            NULL);
            nextFrame.origin.y += ceilf(dimension.height);
            CFRelease(framesetter);
        }
    }
}

- (void)drawRect:(CGRect)rect framesetter:(CTFramesetterRef)framesetter stringRange:(CFRange)range context:(CGContextRef)context {
#if 0
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeTranslation(0,-2 * rect.origin.y));
#else
    rect.origin.y *= -1;
#endif
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, range, path, NULL);
    CFRelease(path);
    CTFrameDraw(frame, context);
    CFRelease(frame);
#if DEBUG
    CGSize dimension = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                    range,
                                                                    NULL,
                                                                    rect.size,
                                                                    NULL);
    CGRect bounds = CGRectMake(rect.origin.x, -rect.origin.y, dimension.width, dimension.height);
    [self drawTextBounds:bounds context:context];
#endif
}
/*
- (CGFloat)heightOfStringWithFrame:(CGRect)rect
                       stringRange:(CFRange)range
                       constraints:(CGSize)constraints
                       framesetter:(CTFramesetterRef)framesetter
                           context:(CGContextRef)context {
    CGSize dimension = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                                range,
                                                                                NULL,
                                                                                constraints,
                                                                                NULL);
    KSLog(@"%s dimension:%@",__PRETTY_FUNCTION__, NSStringFromCGSize(dimension));
    
    re
    CGRect rectInDeviceSpace = CGContextConvertRectToDeviceSpace(context, rect);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rectOfText = CGRectApplyAffineTransform(rectInDeviceSpace, CGAffineTransformInvert(CGAffineTransformMakeScale(scale,scale)));
    
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathAddRect(mutablePath, NULL, rectOfText);
    CGContextAddPath(context, mutablePath);
    CGContextDrawPath(context, kCGPathStroke);
    CFRelease(mutablePath);
}
*/
- (CGFloat)maxWidthInAttributedStrings:(NSArray<NSAttributedString *> *)array
                            targetSize:(CGSize)targetSize
                              contenxt:(NSStringDrawingContext *)context {
    CGFloat maxWidth = 0;
    for (NSAttributedString *attributedString in array) {
        CGFloat width = ceilf([attributedString boundingRectWithSize:targetSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                             context:context].size.width);
        maxWidth = width > maxWidth ? width : maxWidth;
    }
    return maxWidth;
}

- (CGFloat)widthOfSignleLineAttributedString:(NSAttributedString *)attributedString {
    assert(NO);
    return 0;
}
@end

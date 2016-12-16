//
//  CTPGCustomView.m
//  Test
//
//  Created by yubinqiang on 16/12/16.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGCustomView.h"

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
    
    CGFloat maxWidthOfProperty = [self maxWidthInAttributedStrings:@[[[NSAttributedString alloc] initWithString:(__bridge NSString*)propertyOfWord]]
                                                        targetSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)
                                                          contenxt:NULL];
    CGFloat maxWidthOfPropertyIncludeGap = arc4random()%150 + maxWidthOfProperty;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(mutableAttributedString);
    
    CGMutablePathRef mutablePathOfProperty = CGPathCreateMutable();
    CGPathAddRect(mutablePathOfProperty, NULL, CGRectMake(0, 0, maxWidthOfProperty, CGRectGetHeight(self.bounds)));

    CTFrameRef propertyOfFrame = CTFramesetterCreateFrame(framesetter,
                                                          CFRangeMake(0, CFStringGetLength(propertyOfWord)),
                                                          mutablePathOfProperty,
                                                          NULL);
    CTFrameDraw(propertyOfFrame, context);
    CFRelease(propertyOfFrame);
    //
    // Create a path which bounds the area where you will be drawing text.
    // The path need not be rectangular.
    CGMutablePathRef mutablePathOfParaphrase = CGPathCreateMutable();
    CGPathAddRect(mutablePathOfParaphrase,
                  NULL,
                  CGRectMake(maxWidthOfPropertyIncludeGap, 0,
                             CGRectGetWidth(self.bounds) - maxWidthOfPropertyIncludeGap, CGRectGetHeight(self.bounds)));



    
    // Create a frame.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(CFStringGetLength(propertyOfWord), 0), mutablePathOfParaphrase, NULL);
    
    // Draw the specified frame in the given context.
    CTFrameDraw(frame, context);
    
    // Release the objects we used.
    CFRelease(frame);
#if DEBUG
    CGSize dimension = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                 CFRangeMake(CFStringGetLength(propertyOfWord), 0),
                                                 NULL,
                                                 CGSizeMake(CGRectGetWidth(self.bounds) - (maxWidthOfPropertyIncludeGap) , CGFLOAT_MAX),
                                                 NULL);
    KSLog(@"%s dimension:%@",__PRETTY_FUNCTION__, NSStringFromCGSize(dimension));
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    
    CGRect textFrame =  CGRectMake(maxWidthOfPropertyIncludeGap, 0, ceilf(dimension.width), ceilf(dimension.height));
    textFrame = CGContextConvertRectToDeviceSpace(context, textFrame);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect deviceFrame = CGRectApplyAffineTransform(textFrame, CGAffineTransformInvert(CGAffineTransformMakeScale(scale,scale)));
    CGPathAddRect(mutablePath, NULL, deviceFrame);
    CGContextAddPath(context, mutablePath);
#endif
    CGContextDrawPath(context, kCGPathStroke);
    CFRelease(mutablePathOfParaphrase);
    CFRelease(framesetter);

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
- (void)drawWithFrame:(CGRect)frame properties:(NSArray<NSString *> *)properties paraphrases:(NSArray<NSString *> *)paraphrases {
    
}
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

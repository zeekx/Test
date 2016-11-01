//
//  CTPGLayoutParagraphView.m
//  Test
//
//  Created by yubinqiang on 16/10/25.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGLayoutParagraphView.h"
#import "math.h"

@implementation CTPGLayoutParagraphView
- (void)drawRect:(CGRect)rect {
    //Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)*.5, CGRectGetHeight(self.bounds)*.5);
    CGContextMoveToPoint(context,0,center.y);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), center.y);
    CGContextMoveToPoint(context, center.x, 0);
    CGContextAddLineToPoint(context, center.x, CGRectGetHeight(self.bounds));
    
    //Flip the context coordinates, in iOS only.
    CGContextTranslateCTM(context, CGRectGetWidth(self.bounds)*0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1, -1);
    
    // Set the text martix
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);

    // Create a path whicn bounds the area where you will be drawing text.
    // The path need not be rectangular
    CGMutablePathRef path = CGPathCreateMutable();
    
    //In this simple example, initialize a rectangular path.
    CGRect bounds = CGRectMake(10, 0, 200, 200);
    bounds = self.bounds;
    bounds.origin.y = 10;
    bounds.size.height = 60;
    bounds.size.width *= .5;
    CGPathAddRect(path, NULL, bounds);
    CGContextAddPath(context, path);
    // Initialize a string
    CFStringRef string = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    CFMutableAttributedStringRef mutableAttributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString(mutableAttributedString, CFRangeMake(0, 0), string);
    CFRelease(string);
    CFAttributedStringSetAttribute(mutableAttributedString, CFRangeMake(0, 12), kCTForegroundColorAttributeName, [UIColor blueColor].CGColor);
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString(mutableAttributedString);
    CFRelease(mutableAttributedString);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CGContextStrokePath(context);
    
    CFRelease(path);
    CFRelease(ctFrame);
    CFRelease(ctFramesetter);
}
@end

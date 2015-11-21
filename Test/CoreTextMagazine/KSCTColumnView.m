//
//  KSCTColumnView.m
//  Test
//
//  Created by yubinqiang on 15/11/21.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import "KSCTColumnView.h"

@implementation KSCTColumnView


- (void)layoutSubviews {
    [self setNeedsDisplay];
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1.0F, -1.0F);
    
//    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
//    CGMutablePathRef mutablePath = CGPathCreateMutable();
//    CGPathAddRect(mutablePath, NULL, self.bounds);
//    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRangeMake(0, self.attributedString.length), mutablePath, NULL);
    
    CTFrameDraw(self.ctFrame, context);
    
//    CFRelease(mutablePath);
//    CFRelease(ctFramesetter);
//    CFRelease(ctFrame);
}

@end

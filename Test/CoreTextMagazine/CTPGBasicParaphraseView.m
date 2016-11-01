
//
//  CTPGBasicParaphraseView.m
//  Test
//
//  Created by yubinqiang on 16/10/27.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGBasicParaphraseView.h"

@implementation CTPGBasicParaphraseView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 
 
 // Initialize a graphics context in iOS.
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 
 // Flip the context coordinates, in iOS only.
 CGContextTranslateCTM(context, 0, self.bounds.size.height);
 CGContextScaleCTM(context, 1.0, -1.0);
 //
 //    // Initializing a graphic context in OS X is different:
 //    // CGContextRef context =
 //    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
 //
 // Set the text matrix.
 CGContextSetTextMatrix(context, CGAffineTransformIdentity);
 NSAttributedString *propertyOfWord = [[NSAttributedString alloc] initWithString:@"TEXT"];
 
 CTFramesetterRef propertyOfFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)propertyOfWord);
 CGMutablePathRef mutablePathOfProperty = CGPathCreateMutable();
 CGPathAddRect(mutablePathOfProperty, NULL, CGRectMake(0, 0, 100, CGRectGetWidth(self.bounds)));
 CGContextAddPath(context, mutablePathOfProperty);
 CTFrameRef propertyOfFrame = CTFramesetterCreateFrame(propertyOfFramesetter, CFRangeMake(0, 0), mutablePathOfProperty, NULL);
 //    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)propertyOfWord);
 //    CTLineDraw(line, context);
 CTFrameDraw(propertyOfFrame, context);
 
 //
 //    // Create a path which bounds the area where you will be drawing text.
 //    // The path need not be rectangular.
 CGMutablePathRef path = CGPathCreateMutable();
 //
 //    // In this simple example, initialize a rectangular path.
 CGRect bounds = CGRectMake(10.0, 200.0, 200.0, 200.0);
 bounds = self.bounds;
 CGFloat widthOfProperty = 100;
 bounds.origin = CGPointMake(widthOfProperty, bounds.origin.y);
 
 
 //    CGContextSetTextPosition(context, 0, 200);
 
 //    CGContextFillRect(context, bounds);
 // Initialize a string.
 CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
 
 // Create a mutable attributed string with a max length of 0.
 // The max length is a hint as to how much internal storage to reserve.
 // 0 means no hint.
 CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
 
 // Copy the textString into the newly created attrString
 CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), textString);
 
 // Create a color that will be added as an attribute to the attrString.
 CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
 CGFloat components[] = { 1.0, 0.0, 0.0, 0.8 };
 CGColorRef red = CGColorCreate(rgbColorSpace, components);
 CGColorSpaceRelease(rgbColorSpace);
 
 // Set the color of the first 12 chars to red.
 CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12), kCTForegroundColorAttributeName, red);
 
 // Create the framesetter with the attributed string.
 CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
 CFRelease(attrString);
 
 // Create a frame.
 CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
 
 // Draw the specified frame in the given context.
 CTFrameDraw(frame, context);
 
 // Release the objects we used.
 CFRelease(frame);
 CFRelease(path);
 CFRelease(framesetter);
}

@end

//
//  CTPGSimpleTextView.m
//  Test
//
//  Created by yubinqiang on 16/10/25.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGSimpleTextView.h"

@implementation CTPGSimpleTextView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CFStringRef string = CFSTR("Hello, World!");
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithNameAndSize(CFSTR("System"), 17);
    CTFontRef font = CTFontCreateWithFontDescriptor(fontDescriptor, 17, &CGAffineTransformIdentity);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1, -1);
    // Initialize the string, font, and context
    
    CFStringRef keys[] = { kCTForegroundColorAttributeName,kCTFontAttributeName };
    CFTypeRef values[] = { [UIColor blueColor].CGColor,font};
    
    CFDictionaryRef attributes =
    CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                       (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                       &kCFTypeDictionaryKeyCallBacks,
                       &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CFRelease(string);
    CFRelease(attributes);
    
    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    
    // Set text position and draw the line into the graphics context
    CGContextSetTextPosition(context, 10.0, 100.0);
    CTLineDraw(line, context);
    CFRelease(line);
}


@end

//
//  PDFPageView.m
//  PDF in Objective-C
//
//  Created by Milo on 2017/9/20.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "PDFPageView.h"

@implementation PDFPageView

+ (Class)layerClass {
    return [CATiledLayer class];
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, self.bounds);
    
    if(self.page == NULL) {
        assert(false);
        return;
    }
    
    CGContextSaveGState(context);
    
    //    CGContextScaleCTM(context, 1, -1);
    //    CGContextTranslateCTM(context, 0, -self.height);
    CGContextDrawPDFPage(context, self.page);
    CGContextRestoreGState(context);
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self setNeedsDisplay];
//}
@end

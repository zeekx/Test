//
//  KSCoreTextView.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTView.h"
#import "KSCTData.h"
#import "UIView+CGRect.h"
#import "KSCTImageData.h"

@implementation KSCTView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.layer.borderWidth = 0.5F;
    self.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1.0F, -1.0F);
    
    if (self.ctData) {
        CTFrameDraw(self.ctData.ctFrame, context);
    }
    //图片替换
    for (KSCTImageData * imageData in self.ctData.externInfo) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.bounds, image.CGImage);
        }
    }
}


@end

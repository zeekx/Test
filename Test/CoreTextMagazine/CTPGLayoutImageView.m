//
//  CTPGLayoutImageView.m
//  Test
//
//  Created by yubinqiang on 16/10/27.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGLayoutImageView.h"

@implementation CTPGLayoutImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 步骤1：得到当前用于绘制画布的上下文，用于后续将内容绘制在画布上
    // 因为Core Text要配合Core Graphic 配合使用的，如Core Graphic一样，绘图的时候需要获得当前的上下文进行绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)*.5, CGRectGetHeight(self.bounds)*.5);
    CGContextMoveToPoint(context,0,center.y);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), center.y);
    CGContextMoveToPoint(context, center.x, 0);
    CGContextAddLineToPoint(context, center.x, CGRectGetHeight(self.bounds));
    //    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    // 步骤2：翻转当前的坐标系（因为对于底层绘制引擎来说，屏幕左下角为（0，0））
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //    CGContextTranslateCTM(context, CGRectGetWidth(self.bounds)*.5, CGRectGetHeight(self.bounds)*.5);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1.0, -1.0);
    //    CGContextTranslateCTM(context, 100, 0);
    //    CGContextRotateCTM(context, -60 * M_PI/180);
    UIImage *image = [UIImage imageNamed:@"Sample"];
    CGRect frame = CGRectMake(10, 100, image.size.width, image.size.height);
    //    frame = CGRectMake(10, 0, image.size.width, image.size.height);
    
    CGRect newFrame = CGRectApplyAffineTransform(frame,CGContextGetCTM(context));
    NSLog(@"%s frame%@ -> newFrame%@",__PRETTY_FUNCTION__,NSStringFromCGRect(frame),NSStringFromCGRect(newFrame));
    newFrame = CGRectApplyAffineTransform(frame, CGContextGetUserSpaceToDeviceSpaceTransform(context));
    NSLog(@"%s frame%@ -> newFrame%@",__PRETTY_FUNCTION__,NSStringFromCGRect(frame),NSStringFromCGRect(newFrame));
    newFrame = CGContextConvertRectToUserSpace(context, frame);
    NSLog(@"%s frame%@ -> newFrame%@",__PRETTY_FUNCTION__,NSStringFromCGRect(frame),NSStringFromCGRect(newFrame));
    newFrame = CGContextConvertRectToDeviceSpace(context, frame);
    NSLog(@"%s frame%@ -> newFrame%@",__PRETTY_FUNCTION__,NSStringFromCGRect(frame),NSStringFromCGRect(newFrame));
    
    
    CGContextDrawImage(context, frame, image.CGImage);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect deviceFrame = CGRectApplyAffineTransform(newFrame, CGAffineTransformInvert(CGAffineTransformMakeScale(scale,scale)));
    NSLog(@"%s newFrame%@ -> deviceFrame%@",__PRETTY_FUNCTION__,NSStringFromCGRect(newFrame),NSStringFromCGRect(deviceFrame));
    frame = deviceFrame;
    //    CGContextDrawImage(context, frame, image.CGImage);
    
    // 步骤3：创建NSAttributedString
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"TEXT TEST"];
    
    // 步骤4：根据NSAttributedString创建CTFramesetterRef
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    // 步骤5：创建绘制区域CGPathRef
    CGRect PathBoundingBox = CGContextGetPathBoundingBox(context);
    NSLog(@"%s PathBoundingBox:%@",__PRETTY_FUNCTION__, NSStringFromCGRect(PathBoundingBox));
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = self.bounds;
    bounds = CGRectMake(20, 20, 200, 200);
    //    bounds.origin = CGPointMake(10, 20);
    //    bounds = self.bounds;
    CGPathAddRect(path, NULL, bounds);
    //    CGPathAddEllipseInRect(path, NULL, self.bounds);
    [[UIColor lightGrayColor] set];
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    //    CGContextFillEllipseInRect(context, self.bounds);
    
    // 步骤6：根据CTFramesetterRef和CGPathRef创建CTFrame；
    CTFrameRef ctframe = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attrString length]), path, NULL);
    
    // 步骤7：CTFrameDraw绘制
    CTFrameDraw(ctframe, context);
    
    // 步骤8.内存管理
    CFRelease(ctframe);
    CFRelease(path);
    CFRelease(frameSetter);
    
}

@end

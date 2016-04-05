//
//  ViewController.m
//  CALayer1
//
//  Created by yubinqiang on 15/8/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(0, 0, 200, 200);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:blueLayer];
    blueLayer.delegate = self;
//    self.layerView.backgroundColor = [UIColor grayColor];
//    self.layerView.bounds = CGRectMake(self.layerView.bounds.origin.x, self.layerView.bounds.origin.y,
//                                       snowManImageView.size.width, snowManImageView.size.height);
//    self.layerView.layer.contents = (__bridge id)snowManImageView.CGImage;
//    self.layerView.layer.contentsGravity = kCAGravityCenter;
//    self.layerView.layer.contentsScale = .25;
//    self.layerView.layer.masksToBounds = YES;
//    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [blueLayer display];
}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //red circle
    CGContextSetLineWidth(ctx, 12.0F);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

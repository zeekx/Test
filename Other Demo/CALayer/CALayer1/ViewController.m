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
    blueLayer.frame = CGRectMake(10, 10, 200, 200);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
//    [self.layerView.layer addSublayer:blueLayer];
//    self.layerView.contentMode = UIViewContentModeScaleAspectFit;
    self.layerView.backgroundColor = [UIColor grayColor];
    UIImage *snowManImageView = [UIImage imageNamed:@"SnowMan"];
    self.layerView.bounds = CGRectMake(self.layerView.bounds.origin.x, self.layerView.bounds.origin.y,
                                       snowManImageView.size.width, snowManImageView.size.height);
    self.layerView.layer.contents = (__bridge id)snowManImageView.CGImage;
    self.layerView.layer.contentsGravity = kCAGravityCenter;
    self.layerView.layer.contentsScale = .25;
    self.layerView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

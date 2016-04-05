//
//  ViewController.m
//  CALayer7.1
//
//  Created by yubinqiang on 16/2/17.
//  Copyright © 2016年 Kingsoft. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) CALayer *layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layer = [[CALayer alloc] init];
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    CGFloat width = 100;
    CGFloat height = 62;
    self.layer.frame = CGRectMake((CGRectGetWidth(self.colorView.bounds)-width)*.5, 2, width, height);
    [self.colorView.layer addSublayer:self.layer];
}

- (IBAction)changeColor:(UIButton *)sender {
//    [CATransaction setDisableActions:YES];
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    [CATransaction setCompletionBlock:^{
        self.layer.affineTransform = CGAffineTransformRotate(self.layer.affineTransform, M_PI_2);
//        self.layer.bounds = CGRectInset(self.layer.bounds, -30, -30);
    }];
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

    [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
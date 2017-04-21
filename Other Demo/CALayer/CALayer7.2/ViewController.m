//
//  ViewController.m
//  CALayer7.2
//
//  Created by 51Talk_iGS on 2017/4/21.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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
    [CATransaction begin];
    NSLog(@"%s duration:%f",__PRETTY_FUNCTION__, [CATransaction animationDuration]);
    [CATransaction setAnimationDuration:.25 * 10];
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    [CATransaction commit];
}


@end

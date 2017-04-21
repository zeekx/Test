//
//  ViewController.m
//  CALayer7.2.1
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
    self.layer.bounds = CGRectMake(0, 0, width, height);
    self.layer.position = CGPointMake(100, 80);
    [self.colorView.layer addSublayer:self.layer];
}

- (IBAction)changeColor
{
    [CATransaction begin];

    [CATransaction setAnimationDuration:.25 * 10];

    [CATransaction setCompletionBlock:^{
        self.layer.affineTransform = CGAffineTransformRotate(self.layer.affineTransform, M_PI_2);
    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction commit];
}

@end

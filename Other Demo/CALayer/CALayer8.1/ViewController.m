//
//  ViewController.m
//  CALayer8.1
//
//  Created by yubinqiang on 16/2/25.
//  Copyright © 2016年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) CALayer *colorLayer;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //create sublayer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
}
- (IBAction)changeColor {
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"backgroundColor";
    basicAnimation.delegate = self;
    basicAnimation.toValue = (__bridge id)color.CGColor;
    [self.colorLayer addAnimation:basicAnimation forKey:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animationDidStop:(CABasicAnimation*)anim finished:(BOOL)flag {
    if (flag) {
        [CATransaction setDisableActions:YES];
        [CATransaction begin];
        self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
        [CATransaction commit];
    }
}
@end

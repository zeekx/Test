//
//  ViewController.m
//  CALayer8.1.3
//
//  Created by yubinqiang on 16/3/18.
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
    self.colorLayer.frame = self.layerView.bounds;
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    //add it to our view
    [self.layerView.layer addSublayer:self.colorLayer];
}
- (IBAction)changeColor {
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animation];
    keyframeAnimation.keyPath = @"backgroundColor";
    keyframeAnimation.duration = 2;
    keyframeAnimation.values = @[(__bridge id)[UIColor redColor].CGColor,
                                 (__bridge id)[UIColor greenColor].CGColor,
                                 (__bridge id)[UIColor blueColor].CGColor,
                                 (__bridge id)[UIColor redColor].CGColor];
    [self.colorLayer addAnimation:keyframeAnimation forKey:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)animationDidStop:(CABasicAnimation*)anim finished:(BOOL)flag {
//    if (flag) {
//        [CATransaction setDisableActions:YES];
//        [CATransaction begin];
//        self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
//        [CATransaction commit];
//    }
//}
@end

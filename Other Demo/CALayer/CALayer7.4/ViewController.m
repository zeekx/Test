//
//  ViewController.m
//  CALayer7.4
//
//  Created by yubinqiang on 16/2/25.
//  Copyright © 2016年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) CALayer *colorLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorLayer = [CALayer new];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(CGRectGetWidth(self.view.bounds) * .5, CGRectGetHeight(self.view.bounds) * .5);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if ([self.colorLayer.presentationLayer hitTest:touchPoint]) {
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        
    } else {
        NSLog(@"-position:%@", NSStringFromCGPoint(self.colorLayer.position));
        [CATransaction begin];
        [CATransaction setAnimationDuration:5];
        self.colorLayer.position = touchPoint;
        [CATransaction commit];
        NSLog(@"+position:%@", NSStringFromCGPoint(self.colorLayer.position));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"pos:%@",NSStringFromCGPoint(self.colorLayer.presentationLayer.position));
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

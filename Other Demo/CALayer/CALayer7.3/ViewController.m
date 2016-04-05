//
//  ViewController.m
//  CALayer7.3
//
//  Created by yubinqiang on 16/2/17.
//  Copyright © 2016年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) CATransition *transition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;

//    NSLog(@"%@ Outside",[self.colorView.layer actionForKey:@"backgroundColor"]);
//    [UIView beginAnimations:nil context:NULL];
//    NSLog(@"%@ Inside",[self.colorView.layer actionForKey:@"backgroundColor"]);
//    [UIView commitAnimations];
    self.layer = [[CALayer alloc] init];
    self.layer.frame = CGRectMake(50, 2, 100, 100);
    self.layer.backgroundColor = [UIColor blueColor].CGColor;
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    NSMutableDictionary *mutableDictionary = self.layer.actions.mutableCopy;
    [mutableDictionary setValue:transition forKey:@"backgroundColor"];
    self.layer.actions = mutableDictionary;
    self.colorView.layer.actions = @{@"backgroundColor":transition};
//    [self.colorView.layer addSublayer:self.layer];
    self.transition = transition;
}

- (IBAction)changeColor:(UIButton *)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.6];
//    [CATransaction setCompletionBlock:^{
//        self.colorView.layer.affineTransform = CGAffineTransformRotate(self.colorView.layer.affineTransform, M_PI_2);
//    }];
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.colorView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
//    self.colorView.layer.opacity = 1;
    [self.colorView.layer addAnimation:self.transition forKey:@"opacity"];
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

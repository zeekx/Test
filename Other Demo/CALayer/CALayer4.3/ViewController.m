//
//  ViewController.m
//  CALayer4.3
//
//  Created by yubinqiang on 15/9/17.
//  Copyright © 2015年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) CALayer *layer;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layer = [CALayer layer];
    self.layer.frame = CGRectMake(50, 50, 240, 120);
    [self.view.layer addSublayer:self.layer];
    self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"SnowMan"].CGImage);
    
//    self.layer.shadowColor    = [UIColor blackColor].CGColor;
//    self.layer.shadowRadius   = 16;
//    self.layer.shadowOffset   = CGSizeMake(10, 10);
//    self.layer.shadowOpacity  = 0.618F;
    
    CGMutablePathRef mutablePathRef = CGPathCreateMutable();
    CGPathAddEllipseInRect(mutablePathRef, NULL, CGRectInset(self.greenView.bounds, -30, -30));
    self.greenView.layer.shadowPath = mutablePathRef;
    CFRelease(mutablePathRef);
//    self.greenView.layer.shadowOffset   = CGSizeMake(6, 6);
//    self.greenView.layer.shadowRadius   = 16;
    self.greenView.layer.shadowOpacity  = 1 - .618;
}
- (IBAction)changeColor:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

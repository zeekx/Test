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
@property (strong, nonatomic) CALayer *blueLayer;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(20, 20, 100, 100);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:self.blueLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self.view];
    NSLog(@"pt:%@",NSStringFromCGPoint(point));
//    CGPoint ptInLayerView = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
//    if ([self.layerView.layer containsPoint:ptInLayerView]) {
//        CGPoint ptInLayer = [self.blueLayer convertPoint:point fromLayer:self.view.layer];
//        if ([self.blueLayer containsPoint:ptInLayer]) {
//            [self showPoint:ptInLayer containedWithLayer:self.blueLayer withLayerName:@"blue"];
//        } else {
//            [self showPoint:ptInLayerView containedWithLayer:self.layerView.layer withLayerName:@"white"];
//        }
//    }
    CALayer *layer = [self.view.layer hitTest:point];
    if (layer == self.blueLayer) {
        [self showPoint:point containedWithLayer:layer withLayerName:@"blue"];
    } else if (layer == self.layerView.layer) {
        [self showPoint:point containedWithLayer:layer withLayerName:@"white"];
    }
}
- (void)showPoint:(CGPoint) point containedWithLayer:(CALayer *)blueLayer withLayerName:(NSString *)name{
    NSLog(@"%@(%@) containd point%@ :%@",
          name,
          NSStringFromCGRect(blueLayer.frame),
          NSStringFromCGPoint(point),
          @([self.blueLayer containsPoint:point]).stringValue);
}
@end

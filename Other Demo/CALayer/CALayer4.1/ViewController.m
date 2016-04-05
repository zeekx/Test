//
//  ViewController.m
//  CALayer4.1
//
//  Created by yubinqiang on 15/9/17.
//  Copyright © 2015年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.redView.layer.cornerRadius = 20.0F;
    self.whiteView.layer.cornerRadius = 20.0F;
    
    self.whiteView.layer.borderWidth = 5;
    self.redView.layer.borderWidth = 5;
//    self.whiteView.layer.masksToBounds = YES;
}
- (IBAction)changeColor:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

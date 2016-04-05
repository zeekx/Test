//
//  ViewController.m
//  CALayer4.2
//
//  Created by yubinqiang on 15/9/17.
//  Copyright © 2015年 Kingsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *snowmanImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.snowmanImageView.layer.borderWidth = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeColor:(UIButton *)sender {
}

@end

//
//  ATViewControllerB.m
//  Test
//
//  Created by yubinqiang on 16/7/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ATViewControllerB.h"

@interface ATViewControllerB ()

@end

@implementation ATViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)handleCloseButtonTouchUpInside:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES
                                                  completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)button:(UIButton *)sender {
}
@end

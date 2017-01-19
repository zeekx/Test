//
//  ATViewControllerBGes.m
//  Test
//
//  Created by yubinqiang on 17/1/11.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "ATViewControllerBGes.h"
#import "ATDismissTransition.h"

@interface ATViewControllerBGes ()<UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) ATDismissTransition *dismissTransition;
@end

@implementation ATViewControllerBGes

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"B";
    self.dismissTransition = [[ATDismissTransition alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleCloseButtonTouchUpInside:(UIButton *)sender {
    if ([self.dismissDelegate respondsToSelector:@selector(dismissViewController:) ]){
        [self.dismissDelegate dismissViewController:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissTransition;
}
@end

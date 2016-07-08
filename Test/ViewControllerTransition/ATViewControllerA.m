//
//  ATViewControllerA.m
//  Test
//
//  Created by yubinqiang on 16/7/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ATViewControllerA.h"
#import "ATViewControllerAnimator.h"
#import "ATViewControllerB.h"

@interface ATViewControllerA ()
@property (strong, nonatomic) ATViewControllerAnimator *animator;
@end

@implementation ATViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.modalTransitionStyle = UIModalPresentationCustom;
    destinationViewController.transitioningDelegate = self;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Slide" sender:nil];
}
#pragma mark
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[ATViewControllerAnimator alloc] init];
}

@end

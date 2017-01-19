//
//  ATViewControllerAGes.m
//  Test
//
//  Created by yubinqiang on 17/1/11.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "ATViewControllerAGes.h"
#import "ATDismissTransition.h"
#import "ATPresentTranstion.h"
#import "ATGesturePercentDrivenInteractiveTransition.h"
#import "ATViewControllerBGes.h"

@interface ATViewControllerAGes ()<ATViewControllerBGesDelegate>
@property (strong, nonatomic) ATGesturePercentDrivenInteractiveTransition *percentInteractiveTransition;
@property (strong, nonatomic) ATDismissTransition *dismissTranstion;
@property (strong, nonatomic) ATPresentTranstion *presentTranstion;
@end

@implementation ATViewControllerAGes
- (void)dismissViewController:(ATViewControllerBGes *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"A";
    // Do any additional setup after loading the view.
    self.percentInteractiveTransition = [[ATGesturePercentDrivenInteractiveTransition alloc] init];
    self.dismissTranstion = [[ATDismissTransition alloc] init];
    self.presentTranstion = [[ATPresentTranstion alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [self.percentInteractiveTransition dismissViewController:vc];
    ((ATViewControllerBGes *)vc).dismissDelegate = self;
    vc.modalTransitionStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentTranstion;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissTranstion;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.percentInteractiveTransition.isInteracting ? self.percentInteractiveTransition : nil;
}
@end

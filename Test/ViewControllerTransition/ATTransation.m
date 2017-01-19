//
//  ATTransation.m
//  Test
//
//  Created by yubinqiang on 17/1/12.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "ATTransation.h"

@implementation ATTransation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.26 * 3;
}

/*
 - (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
 
 UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
 UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
 
 CGRect initRect  = [transitionContext initialFrameForViewController:fromVC];
 CGRect finalRect = CGRectOffset(initRect, 0, [[UIScreen mainScreen]bounds].size.height);
 
 UIView *containerView = [transitionContext containerView];
 [containerView addSubview:toVC.view];
 [containerView sendSubviewToBack:toVC.view];
 
 [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
 fromVC.view.frame = finalRect;
 } completion:^(BOOL finished) {
 [transitionContext completeTransition:YES];
 }];
 }
*/

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toViewController.view.alpha = 0.0F;
                         toViewController.view.transform = CGAffineTransformMakeScale(.382, .382);
                         [toViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end

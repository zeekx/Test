//
//  ATViewControllerAnimator.m
//  Test
//
//  Created by yubinqiang on 16/7/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ATViewControllerAnimator.h"
#import <UIKit/UIKit.h>
@implementation ATViewControllerAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .26 * 3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0.0F;
    toViewController.view.transform = CGAffineTransformMakeScale(.618, .618);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toViewController.view.alpha = 1.0F;
                         toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                         [toViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

/*
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //1
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2
    CGRect finalRect = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalRect, 0, [[UIScreen mainScreen] bounds].size.height);
    
    //3
    [[transitionContext containerView] addSubview:toVC.view];
    
    //4
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.frame = finalRect;
    } completion:^(BOOL finished) {
        //5
        [transitionContext completeTransition:YES];
    }];
}
*/
@end

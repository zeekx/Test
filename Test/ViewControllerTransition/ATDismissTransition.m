//
//  ATGestureDismissDrivenInteractiveTransition.m
//  Test
//
//  Created by yubinqiang on 17/1/11.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "ATDismissTransition.h"

@interface ATDismissTransition ()

@end

@implementation ATDismissTransition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
#if 1
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [[transitionContext containerView] addSubview:toView];
    [[transitionContext containerView] sendSubviewToBack:toView];
/*
    fromView.alpha = 1.0F;
    CGFloat const scale = 1;
    fromView.transform = CGAffineTransformMakeScale(scale, scale);
    [fromView layoutIfNeeded];
*/
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromView.alpha = 0.0F;
                         CGFloat const kScale = 1-.618;
                         fromView.transform = CGAffineTransformMakeScale(kScale, kScale);
                         //fromView.frame = CGRectMake(0, 0, 62,100);
                         [fromView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         //fromView.transform = CGAffineTransformIdentity;
                         BOOL success = ![transitionContext transitionWasCancelled];
                         if (success) {
                             //[toView removeFromSuperview];
                         }
                         [transitionContext completeTransition:success];
                     }];
#else
    
        // Get the set of relevant objects.
        UIView *containerView = [transitionContext containerView];
        UIViewController *fromVC = [transitionContext
                                    viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC   = [transitionContext
                                    viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        // Set up some variables for the animation.
        CGRect containerFrame = containerView.frame;
        CGRect toViewStartFrame = [transitionContext initialFrameForViewController:toVC];
        CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
        CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
        
        // Set up the animation parameters.
        if (self.presenting) {
            // Modify the frame of the presented view so that it starts
            // offscreen at the lower-right corner of the container.
            toViewStartFrame.origin.x = containerFrame.size.width;
            toViewStartFrame.origin.y = containerFrame.size.height;
        }
        else {
            // Modify the frame of the dismissed view so it ends in
            // the lower-right corner of the container view.
            fromViewFinalFrame = CGRectMake(containerFrame.size.width,
                                            containerFrame.size.height,
                                            toView.frame.size.width,
                                            toView.frame.size.height);
        }
        
        // Always add the "to" view to the container.
        // And it doesn't hurt to set its start frame.
        [containerView addSubview:toView];
        toView.frame = toViewStartFrame;
        
        // Animate using the animator's own duration value.
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             if (self.presenting) {
                                 // Move the presented view into position.
                                 [toView setFrame:toViewFinalFrame];
                             }
                             else {
                                 // Move the dismissed view offscreen.
                                 [fromView setFrame:fromViewFinalFrame];
                             }
                         }
                         completion:^(BOOL finished){
                             BOOL success = ![transitionContext transitionWasCancelled];
                             
                             // After a failed presentation or successful dismissal, remove the view.
                             if ((self.presenting && !success) || (!self.presenting && success)) {
                                 //[toView removeFromSuperview];
                             }
                             
                             // Notify UIKit that the transition has finished
                             [transitionContext completeTransition:success];
                         }];
    
#endif
}
@end

//
//  ATGesturePercentDrivenInteractiveTransition.m
//  Test
//
//  Created by yubinqiang on 17/1/11.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "ATGesturePercentDrivenInteractiveTransition.h"

@interface ATGesturePercentDrivenInteractiveTransition ()
@property (readwrite, nonatomic,getter=isInteracting) BOOL interacting;
@property (strong, nonatomic) UIViewController *presentingViewController;
@end

@implementation ATGesturePercentDrivenInteractiveTransition
- (void)dismissViewController:(UIViewController *)viewController {
    self.presentingViewController = viewController;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.presentingViewController.view addGestureRecognizer:pan];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.presentingViewController.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.interacting = YES;
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            //1
            CGFloat const height = MIN([UIScreen mainScreen].bounds.size.height * (1-.618),180);
            CGFloat percent = (translation.y/height) <= 1 ? (translation.y/height):1;
            [self updateInteractiveTransition:percent];
            NSLog(@"%s percent:%%%.1f",__PRETTY_FUNCTION__,percent *100 );
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //2
            if (gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
            self.interacting = NO;
            break;
        }
            
        default:
            break;
    }
}
@end

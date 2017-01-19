//
//  ATGesturePercentDrivenInteractiveTransition.h
//  Test
//
//  Created by yubinqiang on 17/1/11.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATGesturePercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (readonly, nonatomic,getter=isInteracting) BOOL interacting;

- (void)dismissViewController:(UIViewController *)viewController;
@end

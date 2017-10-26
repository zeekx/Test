//
//  ATViewControllerBGes.h
//  Test
//
//  Created by yubinqiang on 17/1/11.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATViewControllerBGes;
@protocol ATViewControllerBGesDelegate <NSObject>
@optional
- (void)dismissViewController:(ATViewControllerBGes *)viewController;
@end

@interface ATViewControllerBGes : UIViewController
@property (weak  , nonatomic) id<ATViewControllerBGesDelegate> dismissDelegate;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

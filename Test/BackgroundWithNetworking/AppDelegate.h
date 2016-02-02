//
//  AppDelegate.h
//  BackgroundWithNetworking
//
//  Created by yubinqiang on 15/12/29.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy, nonatomic) void (^backgroundSessionCompletionHandler) ();
@end


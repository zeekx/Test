//
//  ViewController.h
//  Timer
//
//  Created by yubinqiang on 15/10/8.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) NSDictionary *userInfo;

- (IBAction)startOneOffTimer:sender;

- (IBAction)startRepeatingTimer:sender;
- (IBAction)stopRepeatingTimer:sender;

- (IBAction)createUnregisteredTimer:sender;
- (IBAction)startUnregisteredTimer:sender;
- (IBAction)stopUnregisteredTimer:sender;


- (IBAction)startFireDateTimer:sender;

- (void)targetMethod:(NSTimer*)theTimer;
- (void)invocationMethod:(NSDate *)date;
- (void)countedTimerFireMethod:(NSTimer*)theTimer;
@end


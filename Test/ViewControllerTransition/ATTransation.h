//
//  ATTransation.h
//  Test
//
//  Created by yubinqiang on 17/1/12.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewControllerTransitioning.h>


@interface ATTransation : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) BOOL presenting;
@end

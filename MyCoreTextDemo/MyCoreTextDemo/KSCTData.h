//
//  KSCTData.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCTData : NSObject
@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat    height;
@property (nonatomic, strong) id         externInfo;
+ (KSCTData *)data;
@end

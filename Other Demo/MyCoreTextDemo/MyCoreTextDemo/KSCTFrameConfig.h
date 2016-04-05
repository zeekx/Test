//
//  KSCTFrameParserConfiguration.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface KSCTFrameConfig : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontPointSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;
@end

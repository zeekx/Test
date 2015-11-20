//
//  KSCTFrameParserConfiguration.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTFrameConfig.h"
#import "Macor.h"

@implementation KSCTFrameConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.width = 280.0F;
        self.fontPointSize = 16.0F;
        self.lineSpace = 8.0F;
        self.textColor = RGB(108, 108, 108);
    }
    return self;
}


@end

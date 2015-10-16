//
//  KSCTFrameParser.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCTData.h"
#import "KSCTFrameConfig.h"
#import "Macor.h"

@interface KSCTFrameParser : NSObject
+ (KSCTData *)content:(NSString *)content
                    config:(KSCTFrameConfig *)config;

+ (KSCTData *)dataWithAttributedString:(NSAttributedString *)attributedString
                           config:(KSCTFrameConfig *)config;

+ (NSMutableDictionary *)attributesWithConfiguration:(KSCTFrameConfig *)configuration;

+ (KSCTData *)dataWithTemplateFile:(NSString *)path config:(KSCTFrameConfig *)config;
@end
//
//  KSCTFrameBuilder.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCTData.h"
#import "KSCTFrameConfig.h"

@interface KSCTFrameBuilder : NSObject
+ (KSCTData *)content:(NSString *)content
               config:(KSCTFrameConfig *)config;


/**
 *  使用config中默认的配置，生成一个ctData
 *
 *  @param attributedString <#attributedString description#>
 *  @param config           <#config description#>
 *
 *  @return <#return value description#>
 */
+ (KSCTData *)dataWithAttributedString:(NSAttributedString *)attributedString
                                config:(KSCTFrameConfig *)config;

/**
 *  根据configuration的属性来生成一个可变的字典（默认属性）
 *
 *  @param configuration 文本配置
 *
 *  @return 返回一个含有文本样式（比如字体大小，行间距）的可变字典
 */
+ (NSMutableDictionary *)attributesWithConfiguration:(KSCTFrameConfig *)configuration;


/**
 *  解析模板文件，使用config中的属性作为默认样式
 *
 *  @param path          模板文件的路径
 *  @param config        默认样式
 *
 *  @return 返回KSCTData实例。
 */
+ (KSCTData *)dataWithTemplateFile:(NSString *)path config:(KSCTFrameConfig *)config;
@end
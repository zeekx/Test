//
//  PropertyWithParaphraseOfWord.h
//  Test
//
//  Created by yubinqiang on 16/4/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyWithParaphraseOfWord : NSObject
@property (copy  , nonatomic) NSString *property;
@property (copy  , nonatomic) NSString *paraphrase;
@property (copy  , nonatomic) NSString *content;
@property (readonly, nonatomic) NSUInteger length;

+ (PropertyWithParaphraseOfWord *)PropertyWithParaphraseOfWordWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithProperty:(NSString *)property paraphrase:(NSString *)paraphrase;
@end

//
//  PropertyWithParaphraseOfWord.m
//  Test
//
//  Created by yubinqiang on 16/4/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "PropertyWithParaphraseOfWord.h"

@implementation PropertyWithParaphraseOfWord
+ (PropertyWithParaphraseOfWord *)PropertyWithParaphraseOfWordWithString:(NSString *)string {
    return [[PropertyWithParaphraseOfWord alloc] initWithString:string];
}
- (instancetype)initWithString:(NSString *)string {
    NSArray <NSString *> *parts = [string componentsSeparatedByString:@"."];
    assert(parts.count == 2);
    return [self initWithProperty:parts.firstObject paraphrase:parts.lastObject];
}
- (instancetype)initWithProperty:(NSString *)property paraphrase:(NSString *)paraphrase {
    self = [super init];
    if (self) {
        self.property = [NSString stringWithFormat:@"%@.",property];
        self.paraphrase = paraphrase;
        self.content = [NSString stringWithFormat:@"%@%@\n",self.property, paraphrase];
    }
    return self;
}

- (NSUInteger)length {
    return self.content.length;
}
@end

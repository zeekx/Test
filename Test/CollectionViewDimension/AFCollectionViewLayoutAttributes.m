//
//  AFCollectionViewLayoutAttributes.m
//  Test
//
//  Created by yubinqiang on 16/6/22.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewLayoutAttributes.h"


@implementation AFCollectionViewLayoutAttributes
- (instancetype)copyWithZone:(NSZone *)zone {
    AFCollectionViewLayoutAttributes *layoutAttributes = [super copyWithZone:zone];
    layoutAttributes.layoutMode = self.layoutMode;
    return layoutAttributes;
}

- (BOOL)isEqual:(id)object {
    return [super isEqual:object] && (self.layoutMode == ((AFCollectionViewLayoutAttributes*)object).layoutMode);
}
@end

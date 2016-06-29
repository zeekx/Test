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
    layoutAttributes.maskingValue = self.maskingValue;
    layoutAttributes.shouldReasterize = self.shouldReasterize;
    return layoutAttributes;
}

- (BOOL)isEqual:(id)object {
    BOOL isEqual = [super isEqual:object];
    if (isEqual && [object isKindOfClass:AFCollectionViewLayoutAttributes.class]) {
        AFCollectionViewLayoutAttributes *layoutAttributesObject = (AFCollectionViewLayoutAttributes *)object;
        return (self.shouldReasterize == layoutAttributesObject.shouldReasterize)
                && ABS(self.maskingValue - layoutAttributesObject.maskingValue) < 0.0001;
    } else {
        return NO;
    }
}
@end

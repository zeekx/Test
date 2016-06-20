//
//  AFCollectionViewFlowLayout.m
//  Test
//
//  Created by yubinqiang on 16/6/20.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"

const CGFloat kItemWidth = 100;
const CGFloat kItemHeight = kItemWidth;
#define  kItemSize CGSizeMake(kItemWidth, kItemHeight)

@implementation AFCollectionViewFlowLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.sectionInset = UIEdgeInsetsMake(8.0F, 30, 20, 30);
    self.minimumLineSpacing = 8.0F;
    self.minimumInteritemSpacing = 8.0F;
//    self.itemSize = kItemSize;
    self.headerReferenceSize = CGSizeMake(60, 30);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *arrayOfLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in arrayOfLayoutAttributes) {
        [self applyLayoutAttributes:attributes];
    }
    return arrayOfLayoutAttributes;
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
        [self applyLayoutAttributes:layoutAttributes];
    return layoutAttributes;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
    if (attributes.representedElementKind == nil) {
        CGFloat width = self.collectionViewContentSize.width;
        CGFloat leftMargin = self.sectionInset.left;
        CGFloat rightMargin = self.sectionInset.right;
        
        NSUInteger numberOfItemInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
        CGFloat firstXPosition = (width - (leftMargin + rightMargin)) / (2 * numberOfItemInSection);
        CGFloat xPosition = firstXPosition + (2 * firstXPosition * attributes.indexPath.item);
        attributes.center = CGPointMake(leftMargin + xPosition, attributes.center.y);
        attributes.frame = CGRectIntegral(attributes.frame);
    }
}
@end

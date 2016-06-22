//
//  AFCollectionViewFlowLayout.m
//  Test
//
//  Created by yubinqiang on 16/6/20.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"
#import "AFDecorationView.h"

const CGFloat kItemWidth = 100;
const CGFloat kItemHeight = kItemWidth;
#define  kItemSize CGSizeMake(kItemWidth, kItemHeight)
static NSString *const kAFDecoration = @"Decoration";

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
    [self registerClass:[AFDecorationView class] forDecorationViewOfKind:kAFDecoration];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *arrayOfLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<UICollectionViewLayoutAttributes *> *mutableArrayOfDecorationViewLayoutAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in arrayOfLayoutAttributes) {
        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            UICollectionViewLayoutAttributes *newLayoutAttributes = [self layoutAttributesForDecorationViewOfKind:kAFDecoration
                                                                                                      atIndexPath:attributes.indexPath];
            if (newLayoutAttributes) {
                [mutableArrayOfDecorationViewLayoutAttributes addObject:newLayoutAttributes];
            }
        }
        [self applyLayoutAttributes:attributes];
    }
    [mutableArrayOfDecorationViewLayoutAttributes addObjectsFromArray:arrayOfLayoutAttributes];
    return mutableArrayOfDecorationViewLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind
                                                                                                                     withIndexPath:indexPath];
    if ([elementKind isEqualToString:kAFDecoration])
    {
        UICollectionViewLayoutAttributes *tallestCellAttributes;
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
        for (NSInteger i = 0; i < numberOfCellsInSection; i++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:i
                                                             inSection:indexPath.section];
            UICollectionViewLayoutAttributes *cellAttribtes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];
            if (CGRectGetHeight(cellAttribtes.frame) > CGRectGetHeight(tallestCellAttributes.frame))
            {
                tallestCellAttributes = cellAttribtes;
            }
        }
        CGFloat decorationViewHeight = CGRectGetHeight(tallestCellAttributes.frame) + self.headerReferenceSize.height;
        layoutAttributes.size = CGSizeMake([self collectionViewContentSize].width, decorationViewHeight);
        layoutAttributes.center = CGPointMake([self collectionViewContentSize].width / 2.0f, tallestCellAttributes.center.y);
        // Place the decoration view behind all the cells
        layoutAttributes.zIndex = -1;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
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

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
    self.sectionInset = UIEdgeInsetsMake(8.0F, 15, 20, 15);
    self.itemSize = kItemSize;
    self.minimumLineSpacing = 8.0F;
    self.minimumInteritemSpacing = 8.0F;
    
}

- (void)setLayoutMode:(AFCollectionViewFlowLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    [self invalidateLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *arrayOfLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in arrayOfLayoutAttributes) {
        [self applyLayoutAttributes:attributes];
    }
    return arrayOfLayoutAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
        [self applyLayoutAttributes:layoutAttributes];
    return layoutAttributes;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
    if (attributes.representedElementKind == nil) {
        ((AFCollectionViewLayoutAttributes*)attributes).layoutMode = self.layoutMode;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:flowlayout:layoutModeForItemAtIndexPath:)]) {
            [(id<AFCollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView flowlayout:self layoutModeForItemAtIndexPath:attributes.indexPath];
        }
    }
}

+ (Class)layoutAttributesClass {
    return AFCollectionViewLayoutAttributes.class;
}
@end

//
//  CLCollectionViewFlowLayout.m
//  Test
//
//  Created by yubinqiang on 16/6/30.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CLCollectionViewFlowLayout.h"
@interface CLCollectionViewFlowLayout ()
@property (strong, nonatomic) NSMutableSet *mutableInsertedItemSet;
@property (strong, nonatomic) NSMutableSet *mutableDeletedItemSet;
@property (assign, nonatomic) NSUInteger numberOfCells;
@end

@implementation CLCollectionViewFlowLayout
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
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 16;
    self.itemSize = CGSizeMake(60, 60);
}
- (void)prepareLayout {
    [super prepareLayout];
    self.numberOfCells = [self.collectionView numberOfItemsInSection:0];
}

#pragma mark - Action

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem * _Nonnull updateItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [self.mutableInsertedItemSet addObject:updateItem.indexPathAfterUpdate];
        } else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            [self.mutableDeletedItemSet addObject:updateItem.indexPathBeforeUpdate];
        }
    }];
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    [self.mutableDeletedItemSet removeAllObjects];
    [self.mutableInsertedItemSet removeAllObjects];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ([self.mutableInsertedItemSet containsObject:itemIndexPath]) {
        layoutAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        layoutAttributes.alpha = 0;
        layoutAttributes.transform3D = CATransform3DMakeScale(0.15, 0.15, 1.0);
        layoutAttributes.transform3D = CATransform3DRotate(layoutAttributes.transform3D, M_PI_4, 0, 0, 1);
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.mutableDeletedItemSet containsObject:itemIndexPath]) {
        layoutAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        layoutAttributes.alpha = 0;
        layoutAttributes.transform3D = CATransform3DMakeScale(0.15, 0.15, 1.0);
        layoutAttributes.transform3D = CATransform3DRotate(layoutAttributes.transform3D, -M_PI_4, 0, 0, 1);
    }
    return layoutAttributes;
}
#pragma mark - Lazy
- (NSMutableSet *)mutableInsertedItemSet {
    if (_mutableInsertedItemSet == nil) {
        _mutableInsertedItemSet = [NSMutableSet set];
    }
    return _mutableInsertedItemSet;
}

- (NSMutableSet *)mutableDeletedItemSet {
    if (_mutableDeletedItemSet == nil) {
        _mutableDeletedItemSet = [NSMutableSet set];
    }
    return _mutableDeletedItemSet;
}
@end

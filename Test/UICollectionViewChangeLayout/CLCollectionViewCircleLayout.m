//
//  CLCollectionViewCircleLayout.m
//  Test
//
//  Created by yubinqiang on 16/6/30.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CLCollectionViewCircleLayout.h"

@interface CLCollectionViewCircleLayout ()
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) NSUInteger numberOfCells;
@end


@implementation CLCollectionViewCircleLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.itemSize = CGSizeMake(60, 60);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.bounds.size;
    self.numberOfCells = [self.collectionView numberOfItemsInSection:0];
    self.center = self.collectionView.center;
    self.radius = (MIN(size.width, size.height) *.5 - MIN(self.itemSize.width, self.itemSize.height)) *.618 + MIN(self.itemSize.width, self.itemSize.height);
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.size = self.itemSize;
    CGFloat radius = self.radius;
    if (self.numberOfCells == 1) {
        layoutAttributes.center = self.center;
    } else {
        layoutAttributes.center = CGPointMake(self.center.x + radius * cosf(2 * M_PI * indexPath.item / self.numberOfCells + M_PI), self.center.y + radius * sinf(2 * M_PI * indexPath.item / self.numberOfCells + M_PI));
        NSLog(@"item:%@,*:%f,center:%@\n",@(indexPath.item).stringValue,cosf(2 * M_PI * indexPath.item / self.numberOfCells) ,NSStringFromCGPoint(layoutAttributes.center));
        layoutAttributes.transform3D = CATransform3DMakeRotation((2*M_PI*indexPath.item / self.numberOfCells), 0, 0, 1);
    }
    return layoutAttributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *mutableArray = [NSMutableArray arrayWithCapacity:self.numberOfCells];
    for (NSUInteger i = 0; i < self.numberOfCells; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (layoutAttributes) {
            [mutableArray addObject:layoutAttributes];
        }
    }
    return mutableArray;
}
@end

//
//  AFCollectionViewFlowLayout.m
//  Test
//
//  Created by yubinqiang on 16/6/20.
//  Copyright © 2016年 Zeek. All rights reserved.
//
#import "AFCollectionViewFlowLayout.h"
#import "TTCollectionDecorationView.h"

const CGFloat kItemWidth = 600;
const CGFloat kItemHeight = kItemWidth;
#define  kItemSize CGSizeMake(kItemWidth, kItemHeight)
@interface AFCollectionViewFlowLayout () {
    BOOL _firstScroll;
    CGPoint _lastProposedContentOffset;
}
@end
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
    self.minimumLineSpacing = 20.0F;
    self.minimumInteritemSpacing = 0.0F;
    self.itemSize = kItemSize;
    self.headerReferenceSize = CGSizeMake(150, 30);
//    [self registerClass:TTCollectionDecorationView.class forDecorationViewOfKind:@"D"];
    [self registerNib:[UINib nibWithNibName:@"TTCollectionDecorationView" bundle:nil] forDecorationViewOfKind:@"D"];
}

- (void)prepareLayout {
    [super prepareLayout];
}
//+ (Class)layoutAttributesClass {
//    return AFCollectionViewLayoutAttributes.class;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    CGRect frame = layoutAttributes.frame;
    frame.size = CGSizeMake(1000, 1000);
    layoutAttributes.frame = frame;
    layoutAttributes.zIndex = 2;
    return layoutAttributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *arrayOfLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<UICollectionViewLayoutAttributes *> *mutableArrayOfLayoutAttributesForDecorationView = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *layoutAttributes in arrayOfLayoutAttributes) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryDecorationView) {
            UICollectionViewLayoutAttributes *layoutAttributesForDecorationView = [self layoutAttributesForDecorationViewOfKind:@"D" atIndexPath:layoutAttributes.indexPath];
            [mutableArrayOfLayoutAttributesForDecorationView addObject:layoutAttributesForDecorationView];
        }
    }
    return [arrayOfLayoutAttributes arrayByAddingObjectsFromArray:mutableArrayOfLayoutAttributesForDecorationView];
}

//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray<UICollectionViewLayoutAttributes *> *arrayOfLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
//    CGRect collectionViewVisibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y,
//                                                  CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
//    for (AFCollectionViewLayoutAttributes *attributes in arrayOfLayoutAttributes) {
//        if (CGRectIntersectsRect(attributes.frame, collectionViewVisibleRect)) {
//            [self applyLayoutAttributes:attributes visibleRect:collectionViewVisibleRect];
//        }
//    }
//    return arrayOfLayoutAttributes;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    AFCollectionViewLayoutAttributes *layoutAttributes = (AFCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
//    CGRect collectionViewVisibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y,
//                                                  CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
//    [self applyLayoutAttributes:layoutAttributes visibleRect:collectionViewVisibleRect];
//    return layoutAttributes;
//}

- (void)applyLayoutAttributes:(AFCollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect{
    return;
#define ACTIVE_DISTANCE 100
#define TRANSLATE_DISTANCE 100
#define ZOOM_FACTOR 0.2f
#define FLOW_OFFSET 40
#define INACTIVE_GREY_VALUE 0.6f
    
    
    if (attributes.representedElementKind) {
        return ;
    }
    CGFloat distanceFromVisibleRectToItem = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distanceFromVisibleRectToItem / ACTIVE_DISTANCE;
    // Handy for use in making a number negative selectively
    BOOL isLeft = distanceFromVisibleRectToItem > 0;
    // Default values
    CATransform3D transform = CATransform3DIdentity;
    CGFloat maskAlpha = 0.0f;
    if (ABS(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE) {
        // We're close enough to apply the transform in relation to // how far away from the center we are.
        transform = CATransform3DTranslate( CATransform3DIdentity,
                                           (isLeft? - FLOW_OFFSET : FLOW_OFFSET)*
                                           ABS(distanceFromVisibleRectToItem/TRANSLATE_DISTANCE), 0,
                                           (1 - ABS(normalizedDistance)) * 40000 + (isLeft? 200 : 0));
        // Set the perspective of the transform.
        transform.m34 = -1/(4.6777f * self.itemSize.width);
        // Set the zoom factor.
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance)); transform = CATransform3DRotate(transform,
                                                                                                      (isLeft? 1 : -1) * ABS(normalizedDistance) * 45 * M_PI / 180,
                                                                                                      0,
                                                                                                      1,
                                                                                                      0);
        transform = CATransform3DScale(transform, zoom, zoom, 1);
        attributes.zIndex = 1;
        CGFloat ratioToCenter = (ACTIVE_DISTANCE - ABS(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE;
        // Interpolate between 0.0f and INACTIVE_GREY_VALUE
        maskAlpha = INACTIVE_GREY_VALUE + ratioToCenter * (-INACTIVE_GREY_VALUE);
    } else {
        // We're too far away - just apply a standard
        // perspective transform.
        transform.m34 = -1/(4.6777 * self.itemSize.width);
        transform = CATransform3DTranslate(transform, isLeft? -FLOW_OFFSET : FLOW_OFFSET, 0, 0);
        transform = CATransform3DRotate(transform, (isLeft? 1 : -1) * 45 * M_PI / 180, 0, 1, 0);
        attributes.zIndex = 0;
        maskAlpha = INACTIVE_GREY_VALUE;
    }
    attributes.transform3D = transform;
    // Rasterize the cells for smoother edges.
//    [(AFCollectionViewLayoutAttributes *)attributes setShouldRasterize:YES];
//    [(AFCollectionViewLayoutAttributes *)attributes setMaskingValue:maskAlpha];
}

#pragma mark -
- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
//    NSLog(@"%s size:%@",__PRETTY_FUNCTION__, NSStringFromCGSize(size));
    return size;
}
/*
- (CGPoint) targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
#if 0
    // Returns a point where we want the collection view to stop
    // scrolling at. First, calculate the proposed center of the
    // collection view once the collection view has stopped
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5;
    // Use the center to find the proposed visible rect.
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0.0,
                                     CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    // Get the attributes for the cells in that rect.
    NSArray* array = [self layoutAttributesForElementsInRect:proposedRect];
    // This loop will find the closest cell to proposed center
    // of the collection view.
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        // We want to skip supplementary views
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            // Determine if this layout attribute's cell is closer than
            // the closest we have so far
            CGFloat itemHorizontalCenter = layoutAttributes.center.x;
            if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
                offsetAdjustment = (itemHorizontalCenter - horizontalCenter);
            }
        }
    }
    CGPoint newProposedContentOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//    NSLog(@"%s content offset(%@),proposedContentOffset(%@) ,new(%@)",
//          __PRETTY_FUNCTION__,
//          NSStringFromCGPoint(self.collectionView.contentOffset),
//          NSStringFromCGPoint(proposedContentOffset),
//          NSStringFromCGPoint(newProposedContentOffset));
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
#else
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5;
    //    KSLog(@"%s proposedContentOffset(%@)",__PRETTY_FUNCTION__,NSStringFromCGPoint(proposedContentOffset));
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0,
                                   CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    CGPoint newProposedContentOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    if (_firstScroll) {
        CGFloat offsetX =  proposedContentOffset.x ;
        _lastProposedContentOffset = CGPointMake(offsetX, proposedContentOffset.y);
        _firstScroll = NO;
        return _lastProposedContentOffset;
    }
    if (ABS(self.collectionView.contentOffset.x - proposedContentOffset.x) < 0.0001) {
        CGFloat offsetX = _lastProposedContentOffset.x;
        newProposedContentOffset = CGPointMake(offsetX, proposedContentOffset.y);
        _lastProposedContentOffset = newProposedContentOffset;
        _firstScroll = NO;
        return newProposedContentOffset;
    }
    
    if (_lastProposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5 < newProposedContentOffset.x ) {//向右滑动
        CGFloat offsetX = _lastProposedContentOffset.x + self.itemSize.width + self.minimumLineSpacing;
        newProposedContentOffset = CGPointMake(offsetX, proposedContentOffset.y);
    } else if (_lastProposedContentOffset.x > newProposedContentOffset.x) {
        newProposedContentOffset = CGPointMake(_lastProposedContentOffset.x - (self.itemSize.width + self.minimumLineSpacing), newProposedContentOffset.y);
    } else {
        // Do nothing
    }
    
    _lastProposedContentOffset = newProposedContentOffset;
    _firstScroll = NO;
//    NSLog(@"%s content offset(%@),proposedContentOffset(%@) ,new(%@)",
//          __PRETTY_FUNCTION__,
//          NSStringFromCGPoint(self.collectionView.contentOffset),
//          NSStringFromCGPoint(proposedContentOffset),
//          NSStringFromCGPoint(newProposedContentOffset));
    
    return newProposedContentOffset;
#endif
}
 */
@end

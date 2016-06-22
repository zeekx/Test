//
//  AFCollectionViewFlowLayout.h
//  Test
//
//  Created by yubinqiang on 16/6/20.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCollectionViewLayoutAttributes.h"

@protocol AFCollectionViewDelegateFlowLayout;

@interface AFCollectionViewFlowLayout : UICollectionViewFlowLayout <AFCollectionViewDelegateFlowLayout>
@property (nonatomic, assign) AFCollectionViewFlowLayoutMode layoutMode;
@end

@protocol AFCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
- (void)collectionView:(UICollectionView *)collectionView flowlayout:(AFCollectionViewFlowLayout*)layout layoutModeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

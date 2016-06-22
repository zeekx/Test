//
//  AFCollectionViewLayoutAttributes.h
//  Test
//
//  Created by yubinqiang on 16/6/22.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AFCollectionViewFlowLayoutMode) {
    AFCollectionViewFlowLayoutAspectFit,
    AFCollectionViewFlowLayoutAspectFill
};

@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, assign) AFCollectionViewFlowLayoutMode layoutMode;
@end

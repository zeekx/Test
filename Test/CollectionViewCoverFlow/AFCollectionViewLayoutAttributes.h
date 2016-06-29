//
//  AFCollectionViewLayoutAttributes.h
//  Test
//
//  Created by yubinqiang on 16/6/22.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, assign) BOOL shouldReasterize;
@property (nonatomic, assign) CGFloat maskingValue;
@end

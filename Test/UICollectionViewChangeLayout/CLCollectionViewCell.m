//
//  CLCollectionViewCell.m
//  Test
//
//  Created by yubinqiang on 16/6/30.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CLCollectionViewCell.h"

@implementation CLCollectionViewCell
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.indexLabel.transform = CGAffineTransformInvert(layoutAttributes.transform);
}
@end

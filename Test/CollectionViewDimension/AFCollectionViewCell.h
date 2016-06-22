//
//  AFCollectionViewCell.h
//  Test
//
//  Created by yubinqiang on 16/6/22.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCollectionViewLayoutAttributes.h"

@interface AFCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) AFCollectionViewFlowLayoutMode imageLayoutMode;
@end

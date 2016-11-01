//
//  TTCollectionViewCell.h
//  Test
//
//  Created by yubinqiang on 16/5/11.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (copy  , nonatomic) NSString *text;
@end

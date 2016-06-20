//
//  AFCollectionViewCell.m
//  Test
//
//  Created by yubinqiang on 16/6/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewCell.h"

@implementation AFCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.selectedBackgroundView = [UIView new];
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentView.backgroundColor = self.isSelected ? [UIColor grayColor] : [UIColor whiteColor];
}

@end

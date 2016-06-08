//
//  TTCollectionViewCell.m
//  Test
//
//  Created by yubinqiang on 16/5/11.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "TTCollectionViewCell.h"
@interface TTCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TTCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}
@end

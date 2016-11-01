//
//  TTCollectionDecorationView.m
//  Test
//
//  Created by yubinqiang on 16/8/23.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "TTCollectionDecorationView.h"

@implementation TTCollectionDecorationView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"cat.jpg"];
    }
    return self;
}
@end

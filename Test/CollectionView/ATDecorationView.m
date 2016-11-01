//
//  ATDecorationView.m
//  Test
//
//  Created by yubinqiang on 16/8/19.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ATDecorationView.h"

@implementation ATDecorationView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
@end

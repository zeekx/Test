//
//  AFDecorationView.m
//  Test
//
//  Created by yubinqiang on 16/6/21.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFDecorationView.h"
@interface AFDecorationView ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation AFDecorationView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.image = [UIImage imageNamed:@"binder"];
        self.imageView.contentMode = UIViewContentModeLeft;
        [self addSubview:self.imageView];
    }
    return self;
}
@end

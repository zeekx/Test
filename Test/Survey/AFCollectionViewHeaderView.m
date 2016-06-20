//
//  AFCollectionViewHeaderView.m
//  Test
//
//  Created by yubinqiang on 16/6/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewHeaderView.h"

@interface AFCollectionViewHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation AFCollectionViewHeaderView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLable = [UILabel new];
    [self addSubview:titleLable];
    titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(titleLable);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLable]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewBindings]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLable]"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewBindings]];
    self.titleLabel = titleLable;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
}
- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
}
@end

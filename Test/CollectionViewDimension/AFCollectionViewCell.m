//
//  AFCollectionViewCell.m
//  Test
//
//  Created by yubinqiang on 16/6/22.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewCell.h"
#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5F;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setImageLayoutMode:(AFCollectionViewFlowLayoutMode)imageLayoutMode {
    if (imageLayoutMode == AFCollectionViewFlowLayoutAspectFit) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else if (AFCollectionViewFlowLayoutAspectFill == imageLayoutMode) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:AFCollectionViewLayoutAttributes.class]) {
        [self setImageLayoutMode:((AFCollectionViewLayoutAttributes *)layoutAttributes).layoutMode];
    }
}
@end

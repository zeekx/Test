//
//  CLCollectionViewFlowLayout.m
//  Test
//
//  Created by yubinqiang on 16/6/30.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CLCollectionViewFlowLayout.h"

@implementation CLCollectionViewFlowLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 16;
    self.itemSize = CGSizeMake(60, 60);
}
@end

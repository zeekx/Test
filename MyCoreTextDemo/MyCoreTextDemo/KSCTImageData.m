//
//  KSCTImageData.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/8/5.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTImageData.h"

@implementation KSCTImageData

- (instancetype)initWithImageNamed:(NSString *)name {
    return [self initWithImageNamed:name inBundle:nil];
}
- (instancetype)initWithImageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        NSString *imageName =  [ bundle == nil ? @"" : [bundle bundlePath] stringByAppendingPathComponent:name];
        [self setupWithImageNamed:imageName];
    }
    return self;
}

- (void)setupWithImageNamed:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    KSAssert(image);
    assert(image.size.width > 0 && image.size.height > 0);
    self.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
}
@end

//
//  AFPhotoModel.m
//  Test
//
//  Created by yubinqiang on 16/6/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFPhotoModel.h"
#import <UIKit/UIImage.h>

@implementation AFPhotoModel
+ (instancetype)photoModelWithName:(NSString *)name image:(UIImage *)image {
    AFPhotoModel *model = [[AFPhotoModel alloc] init];
    model.name = name;
    model.image = image;
    return model;
}
@end

@interface AFSelectionModel ()
@property (nonatomic, strong, readwrite) NSArray<AFPhotoModel *> *photoModels;
@end


@implementation AFSelectionModel

+ (instancetype)selectionModelWithPhotoModels:(NSArray<AFPhotoModel *> *)photoModels {
    AFSelectionModel *model = [[AFSelectionModel alloc] init];
    model.photoModels = photoModels;
    return model;
}

@end
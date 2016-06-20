//
//  AFPhotoModel.h
//  Test
//
//  Created by yubinqiang on 16/6/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface AFPhotoModel : NSObject
+ (instancetype)photoModelWithName:(NSString *)name image:(UIImage *)image;
@property (copy  , nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic,getter=isSelected) BOOL selected;
@end

@interface AFSelectionModel : NSObject
+ (instancetype)selectionModelWithPhotoModels:(NSArray<AFPhotoModel *> *)photoModels;
@property (nonatomic, assign) NSUInteger selectedPhotoModelIndex;
@property (nonatomic, strong, readonly) NSArray<AFPhotoModel *> *photoModels;
//@property (nonatomic, readonly,getter=isSelected) BOOL selected;
@end

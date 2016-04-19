//
//  MLTextView.h
//  Test
//
//  Created by yubinqiang on 16/4/14.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTextView : UIView
@property (assign, nonatomic) NSUInteger numberOfColumn;
@property (strong, nonatomic) NSArray<NSTextContainer *> *textContainers;
- (instancetype)initWithLayoutManager:(NSLayoutManager *)layoutManager
                       textContainers:(NSArray<NSTextContainer *> *)textContainers
                       numberOfColumn:(NSUInteger)numberOfColumn;
@end

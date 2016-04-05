//
//  DataViewController.h
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController<NSLayoutManagerDelegate>

@property (assign, nonatomic) NSInteger currentPageIndex;


- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage newIndex:(NSInteger)index otherIndex:(NSInteger)otherIndex;
//- (void)setDataWithTextStorage:(NSTextStorage *)textStorage;
//- (void)setDataWithTextStorage:(NSTextStorage *)textStorage textContainer:(NSTextContainer *)textContainer layoutManager:(NSLayoutManager *)layoutManager;
@end


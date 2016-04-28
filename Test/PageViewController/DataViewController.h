//
//  DataViewController.h
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTextView.h"

@interface DataViewController : UIViewController<NSLayoutManagerDelegate>
@property (strong, nonatomic) MLTextView *textView;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (assign, nonatomic) NSRange glyphRange;
@property (strong, nonatomic) NSMutableArray<UITextView *> *mutableTextViews;

- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage newIndex:(NSInteger)index otherIndex:(NSInteger)otherIndex;
+ (NSUInteger)numberOfColumnInPage;
- (BOOL)updateText;//TODO:起个好名字

+ (NSRange)glyphRangeWithLayoutManager:(NSLayoutManager *)layoutManager textContainers:(NSArray<NSTextContainer *> *)textContainers;
+ (NSArray<NSTextContainer *> *)textContainersWithLayoutManager:(NSLayoutManager *)layoutManager
                                                          index:(NSInteger)currentPageIndex
                                                 numberOfColumn:(NSInteger)numberOfColumn;
@end


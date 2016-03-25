//
//  DataViewController.h
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (assign, nonatomic) NSUInteger currentPageIndex;

- (void)setDataWithTextStorage:(NSTextStorage *)textStorage;
//- (void)setDataWithTextStorage:(NSTextStorage *)textStorage textContainer:(NSTextContainer *)textContainer layoutManager:(NSLayoutManager *)layoutManager;
@end


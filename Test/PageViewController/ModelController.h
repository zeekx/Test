//
//  ModelController.h
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource, NSLayoutManagerDelegate>
@property (assign, nonatomic) NSUInteger numberOfPages;
@property (strong, nonatomic) NSTextStorage *textStorage;
@property (strong, nonatomic) NSLayoutManager *layoutManager;

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index
                        currentViewController:(DataViewController *)currentViewController
                                   storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end


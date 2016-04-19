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
@property (assign, nonatomic,readonly) NSUInteger numberOfPages;
@property (assign, nonatomic) NSUInteger numberOfColumn;
@property (strong, nonatomic) NSLayoutManager *layoutManager;

@property (assign, nonatomic) NSUInteger numberOfColumnForPortait;
@property (assign, nonatomic) NSUInteger numberOfColumnForLandsacpe;
@property (strong, nonatomic) NSTextStorage *textStorage;

@property (strong, nonatomic) NSLayoutManager *layoutManagerForPortrait;
@property (strong, nonatomic) NSLayoutManager *layoutManagerForLandscape;

@property (assign, nonatomic) CGSize textContainerSize;
@property (assign, nonatomic) NSRange glyphRange;
@property (assign, nonatomic) CGFloat spineWidth;
@property (assign, nonatomic) NSUInteger currentShowingIndex;

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index
                        currentViewController:(DataViewController *)currentViewController
                                   storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;
- (NSUInteger)pagesWithPageSize:(CGSize)size ;
@end


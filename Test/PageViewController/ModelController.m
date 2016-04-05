//
//  ModelController.m
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface ModelController ()
@property (assign, nonatomic) CGPoint textContainerInfset;
@end

@implementation ModelController

#pragma mark - Properties

#pragma mark - Setter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self removeObserverNotification];
}

- (void)setup {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"File" withExtension:@"txt"];
    NSError *error = nil;
//    NSString *text = [NSString stringWithContentsOfURL:fileURL
//                                              encoding:NSUTF8StringEncoding
//                                                 error:&error];

//    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithURL:fileURL
//                                                                          options:@{NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType}
//                                                               documentAttributes:nil
//                                                                            error:&error];
    NSLog(@"Read text file to memory START");
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithURL:fileURL
                                                                                               options:@{NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType}
                                                                                    documentAttributes:nil
                                                                                                 error:&error];
    NSLog(@"Read text file to memory END");
    NSMutableParagraphStyle *mutablePargraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    mutablePargraphStyle.lineSpacing = 6;
    mutablePargraphStyle.headIndent = 0;
    mutablePargraphStyle.tailIndent = 0;
    mutablePargraphStyle.firstLineHeadIndent = mutablePargraphStyle.headIndent + 8;
    mutablePargraphStyle.paragraphSpacing = roundf(mutablePargraphStyle.lineSpacing / 0.618);
    mutablePargraphStyle.paragraphSpacingBefore = 10;
    
    UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [mutableAttributeString addAttributes:@{NSParagraphStyleAttributeName:mutablePargraphStyle,
                                            NSFontAttributeName:bodyFont}
                                    range:NSMakeRange(0, mutableAttributeString.length)];
    NSLog(@"Add attributes");
    self.textStorage = [[NSTextStorage alloc] initWithAttributedString:mutableAttributeString];
        NSLog(@"Text storage initial");
    self.textContainerInfset = CGPointMake(10, 20);
    [self addObserverNotification];
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index
                        currentViewController:(DataViewController *)currentViewController
                                   storyboard:(UIStoryboard *)storyboard {
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    if (![dataViewController setupTextViewWithTextStorage:self.textStorage newIndex:index otherIndex:currentViewController.currentPageIndex]) {
        dataViewController = nil;
    };
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    return viewController.currentPageIndex;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    DataViewController *dataViewController = [self viewControllerAtIndex:index currentViewController:(DataViewController *)viewController storyboard:viewController.storyboard];
    return dataViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;

    DataViewController *dataViewController = [self viewControllerAtIndex:index currentViewController:(DataViewController *)viewController storyboard:viewController.storyboard];
    return dataViewController;
}

#pragma mark - Notification
- (void)addObserverNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarWillChangeOrientation) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)removeObserverNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleStatusBarWillChangeOrientation {
    for (NSUInteger i = 0; i < self.textStorage.layoutManagers.firstObject.textContainers.count; i++) {
        [self.textStorage.layoutManagers.firstObject removeTextContainerAtIndex:i];
    }
}
@end

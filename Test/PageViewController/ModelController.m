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
@property (copy  , nonatomic) UIBezierPath *bezierPath;
@property (strong, nonatomic) NSArray<NSValue *> *glyphRanges;
@property (assign, nonatomic) NSInteger NUMBEROFPAGES;
@end

@implementation ModelController

#pragma mark - Properties

- (UIBezierPath *)bezierPath {
    if (_bezierPath == nil) {
        
        CGRect exclusionRect = CGRectZero;

        if (!(self.spineWidth > 0 || self.spineWidth < 0)) {
            exclusionRect = CGRectZero;
            _bezierPath = nil;//[UIBezierPath bezierPath];
        } else {
            CGRect exclusionRect = CGRectMake(floorf((self.textContainerSize.width - self.spineWidth)*.5), 0,
                                              self.spineWidth, self.textContainerSize.height);
            _bezierPath = [UIBezierPath bezierPathWithRect:exclusionRect];
        }
        
    }
    return _bezierPath;
}



- (NSUInteger)numberOfPages {
#if kUseSingleLayoutManager
    assert(self.layoutManager);
    return ceilf(self.layoutManager.textContainers.count * 1.0 / [DataViewController numberOfColumnInPage]);
#else
    assert(self.layoutManagerForLandscape);
    assert(self.layoutManagerForPortrait);
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return ceilf(self.la.textContainers.count * 1.0 / [DataViewController numberOfColumnInPage]);
    } else {
        return ceilf(self.layoutManagerForPortrait.textContainers.count * 1.0 / [DataViewController numberOfColumnInPage]);
    }
#endif
}

#pragma mark - Setter
- (void)setGlyphRange:(NSRange)glyphRange {
    _glyphRange = glyphRange;
}

- (void)setSpineWidth:(CGFloat)spineWidth {
    _spineWidth = spineWidth;
    _bezierPath = nil;
}

- (void)setTextContainerSize:(CGSize)textContainerSize {
    _textContainerSize = textContainerSize;
    _bezierPath = nil;
}

#if kUseSingleLayoutManager
- (void)setNumberOfColumn:(NSUInteger)numberOfColumn {
    assert(self.textStorage.layoutManagers.count > 0);
    self.textStorage.layoutManagers.firstObject.delegate = self;
    assert(self.layoutManager);
    _numberOfColumn = numberOfColumn;
//    if (self.layoutManager.textContainers.count < numberOfColumn) {
//        for (NSUInteger i = numberOfColumn - self.layoutManager.textContainers.count; i > 0; i--) {
//            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.textContainerSize];
//            [self.layoutManager addTextContainer:textContainer];
//        }
//    } else {
//        for (NSUInteger i = self.layoutManager.textContainers.count - numberOfColumn; i > 0; i--) {
//            [self.layoutManager removeTextContainerAtIndex:self.layoutManager.textContainers.count-1];
//        }
//    }
    //remove
    for (NSInteger i = self.layoutManager.textContainers.count-1; i >= 0; i--) {
        [self.layoutManager removeTextContainerAtIndex:i];
    }
    self.NUMBEROFPAGES = 0;
    for (NSUInteger i = numberOfColumn ; i > 0; i--) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.textContainerSize];
        textContainer.size = self.textContainerSize;
        if (self.bezierPath) {
            textContainer.exclusionPaths = @[self.bezierPath];
        }
        
        [self.layoutManager addTextContainer:textContainer];
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:textContainer];
        if (NSLocationInRange(self.glyphRange.location, glyphRange)) {
            self.currentShowingIndex = [self.layoutManager.textContainers indexOfObject:textContainer];
            NSLog(@"%s location:%@ glyphRange:%@, index:%@", __PRETTY_FUNCTION__,@(self.glyphRange.location), NSStringFromRange(glyphRange),@(self.currentShowingIndex));
        }

    }

//    for (NSTextContainer *textContainer in self.layoutManager.textContainers) {
//
//    textContainer.size = self.textContainerSize;
//    if (self.bezierPath) {
//        textContainer.exclusionPaths = @[self.bezierPath];
//    }
//        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:textContainer];
//        if (NSLocationInRange(self.glyphRange.location, glyphRange)) {
//            self.currentShowingIndex = [self.layoutManager.textContainers indexOfObject:textContainer];
//            NSLog(@"%s location:%@ glyphRange:%@, index:%@", __PRETTY_FUNCTION__,@(self.glyphRange.location), NSStringFromRange(glyphRange),@(self.currentShowingIndex));
//            break;
//        }
//        NSLog(@"%s glyphRange:%@",__PRETTY_FUNCTION__, NSStringFromRange(glyphRange));
//    }
//    [self.layoutManager textContainerChangedGeometry:self.layoutManager.textContainers[self.currentShowingIndex]];
}

#else
- (void)setNumberOfColumnForPortait:(NSUInteger)numberOfColumnForPortait {
    assert(self.layoutManagerForPortrait);
    _numberOfColumnForPortait = numberOfColumnForPortait;
        if (self.layoutManagerForPortrait.textContainers.count < numberOfColumnForPortait) {
            for (NSUInteger i = numberOfColumnForPortait - self.layoutManagerForPortrait.textContainers.count; i > 0; i--) {
                NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.textContainerSize];
                [self.layoutManagerForPortrait addTextContainer:textContainer];
            }
        } else {
            for (NSUInteger i = self.layoutManagerForPortrait.textContainers.count - numberOfColumnForPortait; i > 0; i--) {
                [self.layoutManagerForPortrait removeTextContainerAtIndex:self.layoutManagerForPortrait.textContainers.count-1];
            }
        }
}

- (void)setNumberOfColumnForLandsacpe:(NSUInteger)numberOfColumnForLandsacpe {
    assert(self.layoutManagerForLandscape);
    _numberOfColumnForLandsacpe = numberOfColumnForLandsacpe;
    if (self.layoutManagerForLandscape.textContainers.count < numberOfColumnForLandsacpe) {
        for (NSUInteger i = numberOfColumnForLandsacpe - self.layoutManagerForLandscape.textContainers.count; i > 0; i--) {
            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.textContainerSize];
            [self.layoutManagerForLandscape addTextContainer:textContainer];
        }
    } else {
        for (NSUInteger i = self.layoutManagerForLandscape.textContainers.count - numberOfColumnForLandsacpe; i > 0; i--) {
            [self.layoutManagerForLandscape removeTextContainerAtIndex:self.layoutManagerForLandscape.textContainers.count-1];
        }
    }
}

#endif
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
    NSLog(@"Add attributes");
    NSAttributedString *as = [self content];
    self.textStorage = [[NSTextStorage alloc] initWithAttributedString:as];
    NSLog(@"Text storage initial");
    self.textContainerInfset = CGPointMake(10, 20);
    [self addObserverNotification];
    
}
- (NSAttributedString *)content {
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
    return mutableAttributeString;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index
                        currentViewController:(DataViewController *)currentViewController
                                   storyboard:(UIStoryboard *)storyboard {
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    if (![dataViewController setupTextViewWithTextStorage:self.textStorage newIndex:index otherIndex:currentViewController.currentPageIndex]) {
        dataViewController = nil;
    };
    self.glyphRange = dataViewController.glyphRange;
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    return viewController.currentPageIndex;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    self.currentShowingIndex = index;
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
    self.currentShowingIndex = index;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index >= self.numberOfPages) {
        return nil;
    }
    DataViewController *dataViewController = [self viewControllerAtIndex:index currentViewController:(DataViewController *)viewController storyboard:viewController.storyboard];
    return dataViewController;
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController  {
//    return self.numberOfPages;
//}
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    return self.currentShowingIndex;
//}
#pragma mark - Notification
- (void)addObserverNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarWillChangeOrientation) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)removeObserverNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleStatusBarWillChangeOrientation {
//    for (NSUInteger i = 0; i < self.textStorage.layoutManagers.firstObject.textContainers.count; i++) {
//        [self.textStorage.layoutManagers.firstObject removeTextContainerAtIndex:i];
//    }
}
#pragma mark - ???
- (NSUInteger)pagesWithPageSize:(CGSize)size {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self content]];
    NSLog(@"%s line:%d calc start",__PRETTY_FUNCTION__, __LINE__);
    
    CGRect rect = [textStorage boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     context:NULL];
    NSLog(@"%s line:%d calc end.pages:%@",__PRETTY_FUNCTION__, __LINE__, @(ceilf(CGRectGetHeight(rect)/size.height)));
    
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSRange currentGlyphRange = NSMakeRange(NSNotFound, 0);
    NSRange currentCharactersRange = NSMakeRange(NSNotFound, 0);
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
    if (self.bezierPath) {
        textContainer.exclusionPaths = @[self.bezierPath];
    }
    
    NSInteger pages = -1;
    NSMutableArray<NSValue *> *glyphRanges = [NSMutableArray array];
    for(; NSMaxRange(currentGlyphRange) > 0; pages++) {
        [layoutManager addTextContainer:textContainer];
        currentGlyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
        currentCharactersRange = [layoutManager characterRangeForGlyphRange:currentGlyphRange actualGlyphRange:NULL];
        if (currentCharactersRange.location != NSNotFound) {
            [glyphRanges addObject:[NSValue valueWithRange:currentGlyphRange]];
            [textStorage deleteCharactersInRange:currentCharactersRange];
        }
        [layoutManager removeTextContainerAtIndex:0];
//        NSLog(@"%s ch:%@, Glyph:%@",__PRETTY_FUNCTION__, NSStringFromRange(currentCharactersRange), NSStringFromRange(currentGlyphRange));
    }
    NSLog(@"%s line:%d SECONED calc end.pages:%@",__PRETTY_FUNCTION__, __LINE__, @(pages));

    return pages;
}

#pragma mark - Layout manager delegate
- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
    
    self.NUMBEROFPAGES += (layoutFinishedFlag ? 1 : 0);
//    _layoutManagerFinished = YES;
    NSLog(@"%s textContainer:%@, END:%@ pages:%@",__PRETTY_FUNCTION__,textContainer,layoutFinishedFlag ? @"YES" : @"NO",@(self.NUMBEROFPAGES));
    NSLog(@"\n++++++++++\n%@\n++++++++++\n",layoutManager.textContainers);
}

- (void)layoutManager:(NSLayoutManager *)layoutManager textContainer:(NSTextContainer *)textContainer didChangeGeometryFromSize:(CGSize)oldSize {
    NSLog(@"%s textContainer:%@ oldSize:%@",__PRETTY_FUNCTION__,textContainer,NSStringFromCGSize(oldSize));
}

@end

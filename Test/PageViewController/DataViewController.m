//
//  DataViewController.m
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController () {
    BOOL _layoutManagerFinished;

}
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSMutableArray<UITextView *> *mutableTextViews;
@property (strong, nonatomic) NSMutableArray<NSTextContainer *> *mutableTextContainers;
@property (assign, nonatomic) CGPoint divide;
@property (readonly, nonatomic) NSInteger numberOfColumn;
@end

@implementation DataViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _layoutManagerFinished = NO;
//    self.divide = CGPointMake(8, 8);
}

- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage newIndex:(NSInteger)newIndex otherIndex:(NSInteger)otherIndex {
    BOOL result = NO;
    self.currentPageIndex = newIndex;
    NSLayoutManager *layoutManager = textStorage.layoutManagers.firstObject;
#if 0
    if (YES) {//横屏
#else
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {//横屏
#endif
        layoutManager = textStorage.layoutManagers.lastObject;
        layoutManager.delegate = self;
        layoutManager.allowsNonContiguousLayout = YES;
        if (newIndex >= 0 && otherIndex >= 0) {
            CGSize textContainerSize = CGRectInset(self.view.bounds, self.divide.x, self.divide.y).size;
            textContainerSize.width /= self.numberOfColumn;
            [self.mutableTextContainers addObject:[[NSTextContainer alloc] initWithSize:textContainerSize]];
            [self.mutableTextContainers addObject:[[NSTextContainer alloc] initWithSize:textContainerSize]];
            
            if (newIndex > otherIndex) {//下一页
                if (newIndex * self.numberOfColumn == layoutManager.textContainers.count) {
                    assert(self.mutableTextContainers.count == self.numberOfColumn);
                    [layoutManager addTextContainer:self.mutableTextContainers.firstObject];
                    [layoutManager addTextContainer:self.mutableTextContainers.lastObject];
                } else {
                    [self.mutableTextContainers replaceObjectsInRange:NSMakeRange(0, self.mutableTextContainers.count)
                                                 withObjectsFromArray:layoutManager.textContainers
                                                                range:NSMakeRange(self.numberOfColumn * newIndex, self.mutableTextContainers.count)];
                }
            } else if (otherIndex > newIndex) {//上一页
                //TODO:REMOVE TEXT CONTAINER IF NO NEED.
                //            [layoutManager removeTextContainerAtIndex:MAX(0, otherIndex)];
                [self.mutableTextContainers replaceObjectsInRange:NSMakeRange(0, self.mutableTextContainers.count)
                                             withObjectsFromArray:layoutManager.textContainers
                                                            range:NSMakeRange(self.numberOfColumn * newIndex, self.mutableTextContainers.count)];
                
            } else if (newIndex == 0 && otherIndex == 0
                       && layoutManager.textContainers.count == 0) {//初始页
                [layoutManager addTextContainer:self.mutableTextContainers.firstObject];
                [layoutManager addTextContainer:self.mutableTextContainers.lastObject];
            } else {
                assert(NO);
            }
            for (NSInteger i = 0; i < self.numberOfColumn; i++) {
                CGRect frame = CGRectMake(CGRectGetWidth(self.view.bounds) /self.numberOfColumn * i, 0,
                                          CGRectGetWidth(self.view.bounds) /self.numberOfColumn, CGRectGetHeight(self.view.bounds));
                UITextView *textView = [[UITextView alloc] initWithFrame:frame textContainer:self.mutableTextContainers[i]];
                textView.scrollEnabled = NO;
                textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                textView.layer.borderColor = [UIColor blueColor].CGColor;
                textView.layer.borderWidth = 0.5F;
                [self.view addSubview:textView];
                [self.mutableTextViews addObject:textView];
            }
        } else {
            assert(NO);
        }
    } else { //Portrait
        layoutManager.delegate = self;
        layoutManager.allowsNonContiguousLayout = YES;
        NSLog(@"%s text container count:%ld",__PRETTY_FUNCTION__, layoutManager.textContainers.count);
        if (newIndex >= 0 && otherIndex >= 0) {
            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGRectInset(self.view.bounds, self.divide.x, self.divide.y).size];
            
            if (newIndex > otherIndex) {//下一页
                if (newIndex == layoutManager.textContainers.count) {
                    [layoutManager addTextContainer:textContainer];
                } else {
                    textContainer = layoutManager.textContainers[newIndex];
                }
            } else if (otherIndex > newIndex) {//上一页
               //TODO:REMOVE TEXT CONTAINER IF NO NEED.
                //            [layoutManager removeTextContainerAtIndex:MAX(0, otherIndex)];
                textContainer = layoutManager.textContainers[newIndex];
            } else if (newIndex == 0 && otherIndex == 0 && layoutManager.textContainers.count == 0) {//初始页
                [layoutManager insertTextContainer:textContainer atIndex:0];
            } else {
                assert(NO);
            }
            
            UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:textContainer];
            textView.scrollEnabled = NO;
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:textView];
            [self.mutableTextViews insertObject:textView atIndex:0];
        } else {
            assert(NO);
        }

    }
        [self setupGestureRecognizerWithViews:self.mutableTextViews];
        result = _layoutManagerFinished;

    return result;
}


//- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage
//                            newIndex:(NSInteger)newIndex
//                          otherIndex:(NSInteger)otherIndex
//                   deviceOrientation:(UIDeviceOrientation)deviceOrientation {
//
//}
//

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupGestureRecognizerWithViews:(NSArray<UIView *> *)views {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    for (UIView *view in views) {
        [view addGestureRecognizer:tap];
    }
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    NSLog(@"location: %@", NSStringFromCGPoint(location));
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textView.textStorage.length) {
        
        NSRange range;
        NSDictionary *attributes = [textView.textStorage attributesAtIndex:characterIndex effectiveRange:&range];
        [textView.textStorage attributedSubstringFromRange:range];
        NSLog(@"%@, %@ \nstring:%@\n", attributes, NSStringFromRange(range),[textView.textStorage attributedSubstringFromRange:range].string);
        [textView.layoutManager glyphRangeForTextContainer:textView.textContainer];
        [textView.textStorage.string enumerateSubstringsInRange:range
                                                        options:NSStringEnumerationByWords
                                                     usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                                                         if (NSLocationInRange(characterIndex, substringRange)) {
                                                             NSLog(@"%s \n-%@ \nsubStringRange:%@ \n-enclosingRange:%@"
                                                                   ,__PRETTY_FUNCTION__,
                                                                   substring,
                                                                   NSStringFromRange(substringRange),
                                                                   NSStringFromRange(enclosingRange));
                                                         }
                                                     }];
        
        //Based on the attributes, do something
        ///if ([attributes objectForKey:...)] //make a network call, load a cat Pic, etc
        
    }
}

#pragma mark - Layout manager delegate
- (void)layoutManagerDidInvalidateLayout:(NSLayoutManager *)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
    NSLog(@"%s textContainer:%@, END:%@",__PRETTY_FUNCTION__,textContainer,layoutFinishedFlag ? @"YES" : @"NO");
    _layoutManagerFinished = YES;
}

- (void)layoutManager:(NSLayoutManager *)layoutManager textContainer:(NSTextContainer *)textContainer didChangeGeometryFromSize:(CGSize)oldSize {
    NSLog(@"%s textContainer:%@ oldSize:%@",__PRETTY_FUNCTION__,textContainer,NSStringFromCGSize(oldSize));
}

#pragma mark - Lazy properties
- (NSMutableArray<UITextView *> *)mutableTextViews {
    if (_mutableTextViews == nil) {
        _mutableTextViews = [NSMutableArray arrayWithCapacity:self.numberOfColumn];
    }
    return _mutableTextViews;
}

- (NSMutableArray<NSTextContainer *> *)mutableTextContainers {
    if (_mutableTextContainers == nil) {
        _mutableTextContainers = [NSMutableArray arrayWithCapacity:self.numberOfColumn];
    }
    return _mutableTextContainers;
}

- (NSInteger)numberOfColumn {
    return 2;
}
@end

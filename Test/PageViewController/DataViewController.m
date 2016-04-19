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


@property (strong, nonatomic) NSMutableArray<NSTextContainer *> *mutableTextContainers;
@property (assign, nonatomic) CGPoint divide;
@property (readonly, nonatomic) NSUInteger numberOfColumnInPage;
@property (weak  , nonatomic) NSTextStorage *textStorage;
@end

@implementation DataViewController

#pragma mark - Initilization
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

- (void)dealloc {
    [self removeObserverNotification];
}


- (void)setup {
    _layoutManagerFinished = NO;
//    self.divide = CGPointMake(8, 8);
    [self addObserverNotification];
}

- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage newIndex:(NSInteger)newIndex otherIndex:(NSInteger)otherIndex {
    self.currentPageIndex = newIndex;
    self.textStorage = textStorage;
    return [self updateText];
}


//- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage
//                            newIndex:(NSInteger)newIndex
//                          otherIndex:(NSInteger)otherIndex
//                   deviceOrientation:(UIDeviceOrientation)deviceOrientation {
//
//}
//

#pragma mark - Circle of view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)updateText {
    [self.textView removeFromSuperview];
    self.textView = nil;
    BOOL result = NO;
#if kUseSingleLayoutManager
    NSLayoutManager *layoutManager = self.textStorage.layoutManagers.firstObject;

#else
    NSLayoutManager *layoutManager = self.textStorage.layoutManagers.firstObject;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        layoutManager = self.textStorage.layoutManagers.firstObject;
    } else {
        layoutManager = self.textStorage.layoutManagers.lastObject;
    }
#endif
    NSUInteger numberOfPages = ceilf(layoutManager.textContainers.count * 1.0 / self.numberOfColumnInPage);
    if (self.currentPageIndex < numberOfPages) {
        NSMutableArray<NSTextContainer *> *mutabTextContainers = [NSMutableArray arrayWithCapacity:self.numberOfColumnInPage];
        for (NSUInteger i = 0; i < self.numberOfColumnInPage; i++) {
            NSUInteger index = self.currentPageIndex * self.numberOfColumnInPage + i;
            if (index == layoutManager.textContainers.count) {
                break;
            }
            NSTextContainer *textContainer = layoutManager.textContainers[index];
            CGSize size = CGRectInset(self.view.bounds, self.divide.x, self.divide.y).size;
            CGSize columnSize = CGSizeMake(roundf(size.width / self.numberOfColumnInPage), size.height);
//            textContainer.size = columnSize;
            [mutabTextContainers addObject:textContainer];
        }
//        self.textView = [[MLTextView alloc] initWithLayoutManager:layoutManager
//                                                   textContainers:mutabTextContainers
//                                                   numberOfColumn:self.numberOfColumnInPage];
//        self.textView.frame = self.view.bounds;
//        [self.view addSubview:self.textView];
        NSRange glyphRange = NSMakeRange(0, 0);
        for (NSTextContainer *textContainer in mutabTextContainers) {
            NSRange range = [layoutManager glyphRangeForTextContainer:textContainer];
            glyphRange = NSUnionRange(range, glyphRange);
        }
        glyphRange = NSUnionRange([layoutManager glyphRangeForTextContainer:mutabTextContainers.firstObject],
                                  [layoutManager glyphRangeForTextContainer:mutabTextContainers.lastObject]);
        self.glyphRange = glyphRange;
//        NSLog(@"%s glyphRange:%@",__PRETTY_FUNCTION__, NSStringFromRange(glyphRange));
        [self setupTextViewWithTextContainers:mutabTextContainers];
        result = YES;
    }
    return result;
}

- (void)setupTextViewWithTextContainers:(NSArray<NSTextContainer *> *)textContainers {
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    if (textContainers.count == 1) {
        NSTextContainer *textContainer = textContainers.firstObject;
        UITextView *textView =[[UITextView alloc] initWithFrame:CGRectMake(0, 0, textContainer.size.width, textContainer.size.height)
                                                  textContainer:textContainer];
        [self.view addSubview:textView];
        [self.mutableTextViews addObject:textView];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else if (textContainers.count == 2) {
        NSTextContainer *textContainerLeft = textContainers.firstObject;
        NSTextContainer *textContainerRight = textContainers.lastObject;
        UITextView *textViewLeft =[[UITextView alloc] initWithFrame:CGRectMake(0, 0, textContainerLeft.size.width, textContainerLeft.size.height)
                                                  textContainer:textContainerLeft];
        textViewLeft.scrollEnabled = NO;
        textViewLeft.selectable = YES;
        textViewLeft.editable = NO;
        UITextView *textViewRight =[[UITextView alloc] initWithFrame:CGRectMake(textContainerLeft.size.width, 0, textContainerRight.size.width, textContainerRight.size.height)
                                                      textContainer:textContainerRight];
        textViewRight.scrollEnabled = NO;
        textViewRight.selectable = YES;
        textViewRight.editable = NO;
        [self.view addSubview:textViewLeft];
        [self.view addSubview:textViewRight];
        [self.mutableTextViews addObject:textViewLeft];
        [self.mutableTextViews addObject:textViewRight];
        textViewRight.translatesAutoresizingMaskIntoConstraints = NO;
        textViewLeft.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewBindings = NSDictionaryOfVariableBindings(textViewLeft, textViewRight);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textViewLeft(==textViewRight)]-0-[textViewRight]|"
                                                                         options:kNilOptions
                                                                         metrics:nil
                                                                            views:viewBindings]];

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textViewLeft]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewBindings]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textViewRight]|"
                                                                          options:kNilOptions
                                                                          metrics:nil
                                                                            views:viewBindings]];
        [self.view layoutIfNeeded];
    }
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
        _mutableTextViews = [NSMutableArray arrayWithCapacity:self.numberOfColumnInPage];
    }
    return _mutableTextViews;
}

- (NSMutableArray<NSTextContainer *> *)mutableTextContainers {
    if (_mutableTextContainers == nil) {
        _mutableTextContainers = [NSMutableArray arrayWithCapacity:self.numberOfColumnInPage];
    }
    return _mutableTextContainers;
}

- (NSUInteger)numberOfColumnInPage {
    return [[self class] numberOfColumnInPage];
}

+ (NSUInteger)numberOfColumnInPage {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 1 : 1;;
}

#pragma mark - Notification
- (void)addObserverNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarWillChangeOrientation) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)removeObserverNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleStatusBarWillChangeOrientation {
    _layoutManagerFinished = NO;
}
@end

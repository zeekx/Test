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
@property (assign, nonatomic) CGPoint divide;
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
    self.divide = CGPointMake(8, 8);
}

- (BOOL)setupTextViewWithTextStorage:(NSTextStorage *)textStorage index:(NSInteger)newIndex otherIndex:(NSInteger)otherIndex{
    BOOL result = NO;
    self.currentPageIndex = newIndex;
    NSLayoutManager *layoutManager = textStorage.layoutManagers.firstObject;
    layoutManager.delegate = self;
    layoutManager.allowsNonContiguousLayout = YES;
    NSLog(@"%s text container count:%ld",__PRETTY_FUNCTION__, layoutManager.textContainers.count);
    if (newIndex >= 0 && otherIndex >= 0) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGRectInset(self.view.bounds, self.divide.x, self.divide.y).size];
        if (newIndex > otherIndex) {//下一页
            if (newIndex == layoutManager.textContainers.count) {
                [layoutManager addTextContainer:textContainer];
            } else {//if (newIndex < layoutManager.textContainers.count) {
                textContainer = layoutManager.textContainers[newIndex];
            }
        } else if (otherIndex > newIndex) {//上一页
//            [layoutManager removeTextContainerAtIndex:MAX(0, otherIndex)];
            textContainer = layoutManager.textContainers[newIndex];
        } else if (newIndex == 0 && otherIndex == 0
                   && layoutManager.textContainers.count == 0) {//开始页
            [layoutManager insertTextContainer:textContainer atIndex:0];
        } else {
            assert(NO);
        }
        self.textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:textContainer];
        self.textView.scrollEnabled = NO;
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.textView];
        
        [self setupGestureRecognizer];
        result = _layoutManagerFinished;
    } else {
        assert(NO);
    }
    return result;
}

- (void)setDataWithTextStorage:(NSTextStorage *)textStorage {
    NSTextContainer *textContainer = textStorage.layoutManagers.firstObject.textContainers[self.currentPageIndex];
    textContainer.size = CGRectInset(self.view.bounds, self.divide.x, self.divide.y).size;
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:textContainer];
    self.textView.scrollEnabled = NO;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
    
    [self setupGestureRecognizer];
}

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

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [self.textView addGestureRecognizer:tap];
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
@end

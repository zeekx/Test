//
//  DataViewController.m
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController () {

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

- (void)setDataWithTextStorage:(NSTextStorage *)textStorage {
    NSTextContainer *textContainer = textStorage.layoutManagers.firstObject.textContainers[self.currentPageIndex];
    textContainer.size = CGRectInset(self.view.bounds, self.divide.x, self.divide.y).size;
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds
                                    textContainer:textContainer];
    _textView.scrollEnabled = NO;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_textView];
    
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
    [_textView addGestureRecognizer:tap];
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
@end

//
//  MLTextView.m
//  Test
//
//  Created by yubinqiang on 16/4/14.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "MLTextView.h"

@interface MLTextView ()
@property (strong, nonatomic) NSMutableArray<NSValue *> *textOrigins;
// Inset the text container's layout area within the text view's content area
@property(nonatomic, assign) UIEdgeInsets textContainerInset;
@property (assign, nonatomic) NSRange glyphRange;


@property (weak  , nonatomic) NSLayoutManager *layoutManager;

@end

@implementation MLTextView
- (instancetype)initWithLayoutManager:(NSLayoutManager *)layoutManager
                       textContainers:(NSArray<NSTextContainer *> *)textContainers
                       numberOfColumn:(NSUInteger)numberOfColumn {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.numberOfColumn = numberOfColumn;
        self.layoutManager = layoutManager;
        self.textContainers = textContainers;
        assert(self.textContainers.count <= self.numberOfColumn);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    assert(self.layoutManager);
    for (NSUInteger index = 0; index < self.textContainers.count; index++) {
        NSTextContainer *textContainer = self.textContainers[index];
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:textContainer];
        CGPoint location = CGPointMake((index * textContainer.size.width) + self.textContainerInset.left, self.textContainerInset.top);
        
        [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:location];
        
        
        [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:location];
        [self.layoutManager drawsOutsideLineFragmentForGlyphAtIndex:glyphRange.location];
        [self.layoutManager drawUnderlineForGlyphRange:glyphRange underlineType:NSUnderlinePatternDashDotDot
                                        baselineOffset:0
                                      lineFragmentRect:CGRectMake(location.x, location.y, textContainer.size.width, textContainer.size.height)
                                lineFragmentGlyphRange:glyphRange
                                       containerOrigin:location];
    }
}

- (void)layoutSubviews {
    NSLog(@"%s -bounds%@",__PRETTY_FUNCTION__, NSStringFromCGRect(self.bounds));
    [super layoutSubviews];
    if (CGRectGetWidth(self.bounds) > 0) {
        for (NSTextContainer *textContainter in self.textContainers) {
            CGFloat width = (CGRectGetWidth(self.bounds) - self.textContainerInset.left - self.textContainerInset.right);
            CGSize newSize = CGSizeMake(width / MAX(1, self.numberOfColumn), textContainter.size.height);
            textContainter.size = newSize;
        }
        [self setNeedsDisplay];
    }
}

#pragma mark - Lazy properties
- (NSMutableArray<NSValue *> *)textOrigins {
    if (_textOrigins == nil) {
        _textOrigins = [NSMutableArray arrayWithCapacity:self.numberOfColumn];
    }
    return _textOrigins;
}

- (void)setTextContainers:(NSMutableArray<NSTextContainer *> *)textContainers {
    _textContainers = textContainers;
    for (NSTextContainer *textContainter in _textContainers) {
        CGFloat width = (CGRectGetWidth(self.bounds) - self.textContainerInset.left - self.textContainerInset.right);
        CGSize newSize = CGSizeMake(width / MAX(1, self.numberOfColumn), textContainter.size.height);
        textContainter.size = newSize;
    }
    
}
@end

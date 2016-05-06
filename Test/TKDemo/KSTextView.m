//
//  KSTextView.m
//  TKDemo
//
//  Created by yubinqiang on 16/4/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "KSTextView.h"
#import "PropertyWithParaphraseOfWord.h"

@interface KSTextView ()<NSLayoutManagerDelegate>
@property (strong, nonatomic) NSLayoutManager   *layoutManager;
@property (strong, nonatomic) NSTextContainer   *textContainer;
@property (strong, nonatomic) NSTextStorage     *textStorage;
@property (strong, nonatomic) NSArray<PropertyWithParaphraseOfWord *> *propertiesWithParaphrases;
@end

@implementation KSTextView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return  self;
}

- (void)setupWithFrame:(CGRect)frame {
    self.frame = frame;
    
//
    self.propertiesWithParaphrases = @[
//                                       [PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"vt.承认；同意；准许；授予"],
                                       [PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"n.拨款；补助金；授给物（如财产、授地、专有权、补助、拨款等）- 拨款；补助金；授给物（如财产、授地、专有权、补助、拨款等）"]
//                                       ,[PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"n.拨款；补助金；授给物"]

//                                       ,[PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"vi.同意"]
                                       ];
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (PropertyWithParaphraseOfWord *ppw in self.propertiesWithParaphrases) {
        [mutableString appendString:ppw.content];
    }
    
    self.textStorage = [[NSTextStorage alloc] initWithString:mutableString];
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.firstLineHeadIndent = 0;
    [self.textStorage addAttributes:@{
//                                      NSBackgroundColorAttributeName:[UIColor darkGrayColor],
//                                      NSUnderlineStyleAttributeName:@2
//                                      ,NSUnderlineColorAttributeName:[UIColor blackColor],
//                                      NSParagraphStyleAttributeName:mutableParagraphStyle
                                      } range:NSMakeRange(0, self.textStorage.length)];

    
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.layoutManager.delegate = self;
//    self.layoutManager.usesFontLeading = NO;
    [self.textStorage addLayoutManager:self.layoutManager];
    
    self.textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    self.textContainer.lineFragmentPadding = 0;
//    [self.layoutManager addTextContainer:self.textContainer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.textContainer.size = self.bounds.size;
    //Draw
    {
        NSUInteger currentDrawingCharacterRangeLocation = 0;
        CGPoint origin = CGPointMake(0, 0);
        CGFloat lineSpacing = 0;
        CGFloat maxWidthOfProperty = 160;
        
        for (NSUInteger i = 0; i < self.propertiesWithParaphrases.count; i++) {
            
            PropertyWithParaphraseOfWord *ppw = self.propertiesWithParaphrases[i];
            NSRange propertyCharacterRange = NSMakeRange(currentDrawingCharacterRangeLocation, ppw.property.length);
            CGPoint propertyPoint = CGPointMake(0, 0);
            NSRange actualCharacterRange = NSMakeRange(NSNotFound, 0);
            NSRange propertyGlyphRange = [self.layoutManager glyphRangeForCharacterRange:propertyCharacterRange
                                                                     actualCharacterRange:&actualCharacterRange];
            
            NSTextContainer *propertyTextContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
            [self.layoutManager addTextContainer:propertyTextContainer];
            CGRect propertyTextViewFrame = CGRectZero;
            UITextView *propertyTextView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:propertyTextContainer];
            propertyTextView.backgroundColor = [UIColor blueColor];
//            [self addSubview:propertyTextView];
            [self.layoutManager setTextContainer:propertyTextContainer forGlyphRange:propertyGlyphRange];
            
            CGRect propertylineFrameRect = [self.layoutManager lineFragmentRectForGlyphAtIndex:currentDrawingCharacterRangeLocation effectiveRange:NULL];
            
            CGRect propertylineFrameUsedRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:currentDrawingCharacterRangeLocation effectiveRange:NULL];
            CGRect propertyBounding = [self.layoutManager boundingRectForGlyphRange:propertyGlyphRange inTextContainer:propertyTextContainer];
            //            [self.layoutManager drawBackgroundForGlyphRange:propertyGlyphRange atPoint:propertyPoint];
            [self.layoutManager drawGlyphsForGlyphRange:propertyGlyphRange atPoint:propertyPoint];

  
            
            NSRange paraphraseCharacterRange = NSMakeRange(NSMaxRange(propertyCharacterRange), ppw.paraphrase.length);
            NSRange actualParaphraseChracterRange = NSMakeRange(NSNotFound, 0);
            NSRange paraphraseGlyphRange = [self.layoutManager glyphRangeForCharacterRange:paraphraseCharacterRange
                                                                      actualCharacterRange:&actualParaphraseChracterRange];
            
            NSTextContainer *paraphraseTextContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(CGRectGetWidth(self.bounds) - maxWidthOfProperty, CGRectGetHeight(self.bounds))];
            [self.layoutManager addTextContainer:paraphraseTextContainer];
            [self.layoutManager setTextContainer:paraphraseTextContainer forGlyphRange:paraphraseGlyphRange];
            

            [self.layoutManager ensureLayoutForTextContainer:paraphraseTextContainer];
            [self.layoutManager ensureLayoutForGlyphRange:paraphraseGlyphRange];
            
            CGRect propertyUsedRect = [self.layoutManager usedRectForTextContainer:propertyTextContainer];
            CGPoint paraphraseLocation = CGPointMake(maxWidthOfProperty,  CGRectGetMaxY(propertylineFrameUsedRect));
            CGRect paraphraseBounding = [self.layoutManager boundingRectForGlyphRange:paraphraseGlyphRange inTextContainer:paraphraseTextContainer];
            CGRect paraphraseLineFrameRect = [self.layoutManager lineFragmentRectForGlyphAtIndex:NSMaxRange(propertyGlyphRange)
                                                                                    effectiveRange:NULL];
            CGRect paraphraseLineFrameUsedRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(propertyGlyphRange) effectiveRange:NULL];
            CGRect paraphraseTextContainerUsedRect = [self.layoutManager usedRectForTextContainer:paraphraseTextContainer];
            CGPoint paraphrasePoint = CGPointMake(maxWidthOfProperty - CGRectGetMaxX(propertyBounding), -16.8F);

//            paraphrasePoint = CGPointMake(maxWidthOfProperty - CGRectGetWidth(propertyBounding), 0);
//            paraphrasePoint = CGPointZero;
//            [self.layoutManager drawBackgroundForGlyphRange:paraphraseGlyphRange atPoint:CGPointMake(CGRectGetMinX(propertyBounding), -16.8)];
            [self.layoutManager drawGlyphsForGlyphRange:paraphraseGlyphRange atPoint:paraphrasePoint];
            paraphraseTextContainerUsedRect = [self.layoutManager usedRectForTextContainer:paraphraseTextContainer];
            currentDrawingCharacterRangeLocation += (ppw.length);
//            origin.y += 16.8;
        }
    }
}

//- (NSControlCharacterAction)layoutManager:(NSLayoutManager *)layoutManager shouldUseAction:(NSControlCharacterAction)action forControlCharacterAtIndex:(NSUInteger)charIndex {
////    CGRect bounding = [layoutManager boundingRectForGlyphRange:NSMakeRange(charIndex, 1) inTextContainer:self.textContainer];
////    if (CGRectGetMaxX(bounding)) {
////        action |= NSControlCharacterActionLineBreak;
////    }
//    return action;
//}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingBeforeGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 0;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 0;
}
@end
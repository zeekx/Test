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
    self.propertiesWithParaphrases = @[[PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"vt.承认；同意；准许；授予"]
                                       ,[PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"n.拨款；补助金；授给物（如财产、授地、专有权、补助、拨款等）"]
                                       ,[PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"n.拨款；补助金；授给物"]

                                       ,[PropertyWithParaphraseOfWord PropertyWithParaphraseOfWordWithString:@"vi.同意"]
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
//                                      NSUnderlineStyleAttributeName:@2,
//                                      NSUnderlineColorAttributeName:[UIColor blackColor],
//                                      NSParagraphStyleAttributeName:mutableParagraphStyle
                                      } range:NSMakeRange(0, self.textStorage.length)];

    
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.layoutManager.delegate = self;
//    self.layoutManager.usesFontLeading = NO;
    [self.textStorage addLayoutManager:self.layoutManager];
    
    self.textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    self.textContainer.lineFragmentPadding = 0;
    [self.layoutManager addTextContainer:self.textContainer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.textContainer.size = self.bounds.size;
    //Draw
    {
        NSUInteger currentDrawingCharacterRangeLocation = 0;
        CGPoint origin = CGPointMake(0, 0);
        CGFloat lineSpacing = 13.80;
        CGFloat maxWidthOfProperty = 30;
        
        for (NSUInteger i = 0; i < self.propertiesWithParaphrases.count; i++) {
            PropertyWithParaphraseOfWord *ppw = self.propertiesWithParaphrases[i];
            NSRange propertyCharacterRange = NSMakeRange(currentDrawingCharacterRangeLocation, ppw.property.length);
            CGPoint propertyPoint = CGPointMake(origin.x, 0);
            NSRange actualCharacterRange = NSMakeRange(NSNotFound, 0);
            NSRange propertyGlyphRange = [self.layoutManager glyphRangeForCharacterRange:propertyCharacterRange
                                                                     actualCharacterRange:&actualCharacterRange];
            CGPoint propertyLocation = CGPointMake(origin.x, origin.y + lineSpacing * i);
//            [self.layoutManager setLocation:propertyLocation forStartOfGlyphRange:propertyCharacterRange];
            [self.layoutManager drawGlyphsForGlyphRange:propertyGlyphRange atPoint:propertyPoint];

            
            CGRect lineFrameRect = [self.layoutManager lineFragmentRectForGlyphAtIndex:currentDrawingCharacterRangeLocation effectiveRange:NULL];
            CGRect lineFrameUsedRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:currentDrawingCharacterRangeLocation effectiveRange:NULL];
            
            CGPoint locationForGlyphIndex = [self.layoutManager locationForGlyphAtIndex:currentDrawingCharacterRangeLocation];
        
            CGRect boundingForGlyphIndex = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(currentDrawingCharacterRangeLocation, 1) inTextContainer:self.textContainer];
            
            CGRect propertyBounding = [self.layoutManager boundingRectForGlyphRange:propertyCharacterRange inTextContainer:self.textContainer];
            
            
        
            NSRange paraphraseCharacterRange = NSMakeRange(NSMaxRange(propertyCharacterRange), ppw.paraphrase.length);
            NSRange actualParaphraseChracterRange = NSMakeRange(NSNotFound, 0);
            NSRange paraphraseGlyphRange = [self.layoutManager glyphRangeForCharacterRange:paraphraseCharacterRange
                                                                      actualCharacterRange:&actualParaphraseChracterRange];
            
            CGPoint paraphraseLocation = CGPointMake(maxWidthOfProperty,  propertyPoint.y+lineSpacing);
            CGRect paraphraseBounding = [self.layoutManager boundingRectForGlyphRange:paraphraseGlyphRange inTextContainer:self.textContainer];
//            CGRect paraphraseLineFrameRect = [self.layoutManager lineFragmentRectForGlyphAtIndex:currentDrawingCharacterRangeLocation effectiveRange:NULL];
            [self.layoutManager setLocation:paraphraseLocation forStartOfGlyphRange:paraphraseGlyphRange];

            CGPoint paraphrasePoint = CGPointMake(maxWidthOfProperty - CGRectGetMaxX(propertyBounding), propertyPoint.y);
            paraphrasePoint = CGPointMake(0, 0);
            [self.layoutManager drawGlyphsForGlyphRange:paraphraseGlyphRange atPoint:paraphrasePoint];

            currentDrawingCharacterRangeLocation += (ppw.length);
//            origin.y += 13.8;
        }
    }
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingBeforeGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 0;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 0;
}
@end
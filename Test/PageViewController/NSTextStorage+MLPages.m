//
//  NSTextStorage+MLPages.m
//  Test
//
//  Created by yubinqiang on 16/4/14.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "NSTextStorage+MLPages.h"

@implementation NSTextStorage (MLPages)
- (NSUInteger)pagesWithPageSize:(CGSize)size {
    NSLog(@"%s line:%d calc start",__PRETTY_FUNCTION__, __LINE__);
    CGRect rect = [self boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                 context:NULL];
    NSLog(@"%s line:%d calc end.pages:%@",__PRETTY_FUNCTION__, __LINE__, @(ceilf(CGRectGetHeight(rect)/size.height)));

    
    NSLayoutManager *layoutManager = self.layoutManagers.firstObject;
    NSRange currentGlyphRange = NSMakeRange(NSNotFound, 0);
    NSRange currentCharactersRange = NSMakeRange(NSNotFound, 0);
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
    for(NSUInteger pages = 0; NSMaxRange(currentGlyphRange) > 0; pages++) {
         [layoutManager addTextContainer:textContainer];
          currentGlyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
         currentCharactersRange = [layoutManager characterRangeForGlyphRange:currentGlyphRange actualGlyphRange:NULL];
         if (currentCharactersRange.location != NSNotFound) {
             [self deleteCharactersInRange:currentCharactersRange];
         }
        [layoutManager removeTextContainerAtIndex:0];
//        NSLog(@"%s ch:%@, Glyph:%@",__PRETTY_FUNCTION__, NSStringFromRange(currentCharactersRange), NSStringFromRange(currentGlyphRange));
    }
    NSLog(@"%s line:%d SECONED calc end.pages:%@",__PRETTY_FUNCTION__, __LINE__, @(ceilf(CGRectGetHeight(rect)/size.height)));
    
    return ceilf(CGRectGetHeight(rect)/size.height);
}

- (NSUInteger)numberOfColumnWithSize:(CGSize)size {
    NSLog(@"%s line:%d calc start",__PRETTY_FUNCTION__, __LINE__);
    CGRect rect = [self boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     context:NULL];
    NSLog(@"%s line:%d calc end.pages:%@",__PRETTY_FUNCTION__, __LINE__, @(ceilf(CGRectGetHeight(rect)/size.height)));
    return ceilf(CGRectGetHeight(rect)/size.height);
    
}
@end

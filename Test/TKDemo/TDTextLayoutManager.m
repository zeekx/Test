//
//  TDTextLayoutManager.m
//  Test
//
//  Created by yubinqiang on 16/5/5.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "TDTextLayoutManager.h"

@implementation TDTextLayoutManager
- (void)invalidateGlyphsForCharacterRange:(NSRange)charRange changeInLength:(NSInteger)delta actualCharacterRange:(NSRangePointer)actualCharRange {
    [super invalidateGlyphsForCharacterRange:charRange changeInLength:delta actualCharacterRange:actualCharRange];
    
}
@end

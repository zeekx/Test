//
//  KSCTData.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTData.h"
#import "KSCTImageData.h"
@interface KSCTData ()
@end

@implementation KSCTData
+ (KSCTData *)data {
    return [[[self class] alloc] init];
}

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)setExternInfo:(id)externInfo {
    _externInfo = externInfo;
    [self drawImage];
}

- (void)drawImage {
    NSArray *imageArray = nil;
    if ([self.externInfo isKindOfClass:[NSArray class]]) {
        imageArray = self.externInfo;
        if (imageArray.count == 0) {
            return;
        }
    } else {
        KSAssert(NO);
    }
    
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);

    CGPoint linesOrigin[lines.count];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), linesOrigin);
    
    NSInteger imageIndex = 0;
    KSCTImageData *imageData = imageArray.firstObject;
    for (NSInteger index = 0; index < lines.count; index ++) {
        KSLog(@"%s %@",__PRETTY_FUNCTION__, NSStringFromCGPoint(linesOrigin[index]));
        if (imageData == nil) {
            return;
        }
        CTLineRef line = (__bridge CTLineRef)lines[index];
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        for ( id runObj in runs) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent = 0;
            CGFloat descent = 0;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat offsetX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = linesOrigin[index].x + offsetX;
            runBounds.origin.y = linesOrigin[index].y - descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect rect = CGPathGetBoundingBox(pathRef);
            CGRect delegateBounds = CGRectOffset(runBounds, rect.origin.x, rect.origin.y);
            

            
            imageData.bounds = delegateBounds;
            imageIndex ++;
            if (imageIndex == imageArray.count) {
                imageData = nil;
                return;
            } else {
                imageData = imageArray[imageIndex];
            }
        }
    }
}

- (void)dealloc {
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
        _ctFrame = NULL;
    }
}
@end

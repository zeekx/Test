//
//  SVGPolygon.m
//  Test
//
//  Created by yubinqiang on 16/8/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "SVGPolygon.h"

@implementation SVGPolygon
- (instancetype)initWithString:(NSString *)text offset:(SVGPoint *)offset {
    self = [super init];
    if (self) {
        NSUInteger postionStart = @"<polygon points=\"".length-1;
        NSRange colorRange = [text localizedStandardRangeOfString:@" \" fill=\"rgb("];
        NSRange opacityRange = [text localizedStandardRangeOfString:@")\" opacity=\""];
//        NSString *stringOfOpacity = @"\" />";
        
        NSString *stringOfPostion = [text substringWithRange:NSMakeRange(postionStart, colorRange.location - postionStart)];
        NSString *stringOfRGB = [text substringWithRange:NSMakeRange(colorRange.location + colorRange.length, opacityRange.location-(colorRange.location + colorRange.length))];
        NSString *stringOfOpacity = [text substringFromIndex:opacityRange.location + opacityRange.length];
        
        NSArray<NSString *> *positions = [stringOfPostion componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.numberOfVertex = positions.count / 2;
        NSMutableArray<SVGPoint *> *mutableValuseOfPoint = [NSMutableArray arrayWithCapacity:self.numberOfVertex / 2];
        for (NSUInteger i = 0; i < positions.count; i+=2) {
            SVGPoint *point = [[SVGPoint alloc] initWithX:([positions[i] integerValue] + offset.x) y:([positions[i+1] integerValue] + offset.y)];
            [mutableValuseOfPoint addObject:point];
        }
        self.points = mutableValuseOfPoint;
        self.offset = offset;
        
        NSArray<NSString *> *stringOfRGBItem = [stringOfRGB componentsSeparatedByString:@","];
        CGFloat opacity = [stringOfOpacity floatValue];
        self.rgba = [[SVGRGBA alloc] initWithR:[stringOfRGBItem.firstObject integerValue]
                                             G:[stringOfRGBItem[1] integerValue]
                                             B:[stringOfRGBItem.lastObject integerValue]
                                         alpha:opacity];
        
        self.fillColor = [UIColor colorWithRed:[stringOfRGBItem.firstObject integerValue]/255.0
                                         green:[stringOfRGBItem[1] integerValue]/255.0
                                          blue:[stringOfRGBItem.lastObject integerValue]/255.0
                                         alpha:opacity];
    }
    return self;
}

- (NSString *)line {
    NSMutableString *mutableString = [NSMutableString stringWithString:@"<polygon points=\""];
    for (SVGPoint *p in self.points) {
        [mutableString appendFormat:@"%@ %@ ",@(p.x).stringValue, @(p.y).stringValue];
    }
    [mutableString appendString:@" \" fill=\"rgb("];
    [mutableString appendFormat:@"%@,%@,%@)\" opacity=\"",@(self.rgba.r),@(self.rgba.g),@(self.rgba.b)];
    [mutableString appendFormat:@"%f",self.rgba.a];
    [mutableString appendString:@"\" />\n"];
    return mutableString;
}
@end


@implementation SVGPoint

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y {
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}
@end

@implementation SVGRGBA

- (instancetype)initWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b alpha:(CGFloat)a {
    self = [super init];
    if (self) {
        self.r = r;
        self.g = g;
        self.b = b;
        self.a = a;
    }
    return self;
}

@end
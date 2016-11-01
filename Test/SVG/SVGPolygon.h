//
//  SVGPolygon.h
//  Test
//
//  Created by yubinqiang on 16/8/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SVGPoint : NSObject
@property (assign, nonatomic) NSInteger x;
@property (assign, nonatomic) NSInteger y;

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y;
@end

@interface SVGRGBA : NSObject
@property (assign, nonatomic) NSInteger r;
@property (assign, nonatomic) NSInteger g;
@property (assign, nonatomic) NSInteger b;
@property (assign, nonatomic) CGFloat a;

- (instancetype)initWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b alpha:(CGFloat)a;
@end

@interface SVGPolygon : NSObject
@property (strong, nonatomic) NSArray<SVGPoint *> *points;
@property (assign, nonatomic) NSUInteger numberOfVertex;
@property (copy  , nonatomic) UIColor *fillColor;
@property (strong, nonatomic) SVGPoint *offset;
@property (strong, nonatomic) SVGRGBA *rgba;
- (instancetype)initWithString:(NSString *)text offset:(SVGPoint *)offset;
- (NSString *)line;
@end

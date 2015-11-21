//
//  MarkupParser.h
//  Test
//
//  Created by yubinqiang on 15/11/21.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkupParser : NSObject

@property (strong, nonatomic) NSString* font;

@property (strong, nonatomic) UIColor* color;

@property (strong, nonatomic) UIColor* strokeColor;

@property (assign, nonatomic) CGFloat strokeWidth;

@property (strong, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;

@end

//
//  MarkupParser.m
//  Test
//
//  Created by yubinqiang on 15/11/21.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import "MarkupParser.h"

@implementation MarkupParser
- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = @"ArialMT";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSError *regularExpressionError = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&regularExpressionError];
    NSArray *chunks = [regularExpression matchesInString:markup
                                                 options:kNilOptions
                                                   range:NSMakeRange(0, markup.length)];
    for (NSTextCheckingResult* b in chunks) {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 24.0f, NULL);
        //apply the current text style //2
        
        NSDictionary* attrs = @{(NSString *)kCTForegroundColorAttributeName:(id)self.color.CGColor,
                                (NSString *)kCTFontAttributeName:(__bridge id)fontRef,
                                (NSString *)kCTStrokeColorAttributeName:(id)self.strokeColor.CGColor,
                                (NSString *)kCTStrokeWidthAttributeName:@(self.strokeWidth) };
        
        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs]];
        
        CFRelease(fontRef);
        
        //handle new formatting tag //3
        
        if (parts.count > 1) {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"font"]) {
                //stroke color
                NSRegularExpression* scolorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    if ([[tag substringWithRange:match.range] isEqualToString:@"none"]) {
                        self.strokeWidth = 0.0;
                    } else {
                        self.strokeWidth = -3.0;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                }];
                //color
                
                NSRegularExpression* colorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat: @"%@Color", [tag substringWithRange:match.range]]);
                    self.color = [UIColor performSelector:colorSel];
                }];
                
                //face
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    self.font = [tag substringWithRange:match.range];
                }];
            } //end of font parsing
            if ([tag hasPrefix:@"img"]) {
                __block NSNumber *width = @(0);
                __block NSNumber *height = @(0);
                __block NSString *fileName = @"";
                
                NSRegularExpression *widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+"
                                                                                       options:kNilOptions
                                                                                         error:NULL];
                [widthRegex enumerateMatchesInString:tag
                                             options:kNilOptions
                                               range:NSMakeRange(0, tag.length)
                                          usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                              width = @([[tag substringWithRange:result.range] intValue]);
                                          }];
                
                NSRegularExpression *heightRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")\\d[^\"]+"
                                                                                        options:kNilOptions
                                                                                          error:NULL];
                
                [heightRegex enumerateMatchesInString:tag
                                              options:kNilOptions
                                                range:NSMakeRange(0, tag.length)
                                           usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                               height = @([[tag substringWithRange:result.range] intValue]);
                                           }];
                NSRegularExpression *srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+"
                                                                                     options:kNilOptions
                                                                                       error:NULL];
                
                [srcRegex enumerateMatchesInString:tag
                                           options:kNilOptions
                                             range:NSMakeRange(0, tag.length)
                                        usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                            fileName = [tag substringWithRange:result.range];
                                        }];
                
                [self.images addObject:@{@"width":width,
                                         @"height":height,
                                         @"fileName":fileName,
                                         @"location":@(mutableAttributedString.length)}];
                
                CTRunDelegateCallbacks ctRunDelegateCallbacks;
                ctRunDelegateCallbacks.version = kCTRunDelegateVersion1;
                ctRunDelegateCallbacks.getAscent = ascentCallback;
                ctRunDelegateCallbacks.getDescent = descentCallback;
                ctRunDelegateCallbacks.getWidth = widthCallback;
                
                NSDictionary *imageAttribute = @{@"width":width, @"height":height};
                CTRunDelegateRef delegate = CTRunDelegateCreate(&ctRunDelegateCallbacks, (__bridge void * _Nullable)(imageAttribute));
                CGFloat headIndent = 0;
                CGFloat firstLineHeadIndent = 0 + headIndent;

                CTParagraphStyleSetting setting[] = {{kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(firstLineHeadIndent),&firstLineHeadIndent},
                    {kCTParagraphStyleSpecifierHeadIndent,sizeof(headIndent), &headIndent}};
                CTParagraphStyleRef paragraphStyle =  CTParagraphStyleCreate(setting, sizeof(setting)/sizeof(setting[0]));
                NSDictionary *imageAttributeWithDelegate = @{(NSString *)kCTRunDelegateAttributeName:(__bridge id)delegate,
                                                             (NSString *)kCTParagraphStyleAttributeName:(__bridge id)paragraphStyle};
                
                NSAttributedString *as = [[NSAttributedString alloc] initWithString:@" "
                                                                         attributes:imageAttributeWithDelegate];
                [mutableAttributedString appendAttributedString: as];
                
                
            }//tag:image
            
            
            
        }//end of handle new formatting tag
    }
    return mutableAttributedString;
}

/* Callbacks */

static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}
@end

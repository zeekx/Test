//
//  KSCTFrameBuilder.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTFrameBuilder.h"
#import "KSCTImageData.h"

@implementation KSCTFrameBuilder
+ (KSCTData *)content:(NSString *)content
               config:(KSCTFrameConfig *)config {
    NSDictionary *attributes = [[self class] attributesWithConfiguration:config];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    //创建 CTFramesetterRef 的实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeString);
    
    //获取 可用绘制区域的 height
    CGSize constraintSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize ctSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                 CFRangeMake(0,0),
                                                                 NULL,
                                                                 constraintSize,
                                                                 NULL);
    CGFloat textHeight = ctSize.height;
    KSAssert(textHeight > 0);
    //生成 CTFrameRef 实例
    CGPathRef path = [[self class] pathWithRect:CGRectMake(0, 0, config.width, ctSize.height)];
    CTFrameRef ctFrame = [[self class] ctFrameWithFramesetter:framesetter
                                                         path:path];
    //将 ctFrame 和计算好的绘制高度保存到 ctData 中,并将ctData返回
    KSCTData *ctData = [KSCTData data];
    ctData.ctFrame = ctFrame;//retain ctFrame in ctData:setCtFrame:
    ctData.height = textHeight;
    CFRelease(ctFrame);
    CFRelease(framesetter);
    KSAssert(ctData);
    return ctData;
}

+ (CGPathRef)pathWithRect:(CGRect)rect {
    KSAssert(!CGRectIsEmpty(rect));
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathAddRect(mutablePath, NULL, rect);
    return mutablePath;
}


/**
 *  Create a path with config.width and height , The path with framesetter as param via CTFramesetterCreateFrame new a CTFrame.
 *
 *  @param framesetter <#framesetter description#>
 *  @param config      <#config description#>
 *  @param height      <#height description#>
 *
 *  @return A reference to a new CTFrame object if the call was successful; otherwise, NULL
 */
+ (CTFrameRef)ctFrameWithFramesetter:(CTFramesetterRef)framesetter
                                path:(CGPathRef)path{
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    return ctFrame;
}

/**
 *  根据configuration的属性来生成一个可变的字典（默认属性）
 *
 *  @param configuration 文本配置
 *
 *  @return 返回一个含有文本样式（比如字体大小，行间距）的可变字典
 */
+ (NSMutableDictionary *)attributesWithConfiguration:(KSCTFrameConfig *)config {
    CGFloat fontPointSize = config.fontPointSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontPointSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    
    CFIndex const kNumberOfSettings = 3;
    CTParagraphStyleSetting paragraphStyleSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,   sizeof(lineSpacing), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,      sizeof(lineSpacing), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,      sizeof(lineSpacing), &lineSpacing}
    };
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(paragraphStyleSettings,
                                                              sizeof(paragraphStyleSettings)/sizeof(paragraphStyleSettings[0]));
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:(id)config.textColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    [dict setValue:(__bridge id)fontRef forKey:(NSString *)kCTFontAttributeName];
    [dict setValue:(__bridge id)paragraphRef forKey:(NSString *)kCTParagraphStyleAttributeName];
    CFRelease(paragraphRef);
    CFRelease(fontRef);
    return dict;
}


+ (KSCTData *)dataWithAttributedString:(NSAttributedString *)attributedString
                                config:(KSCTFrameConfig *)config {
    
    //创建 CTFramesetterRef 的实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    //获取 可用绘制区域的 height
    CGSize constraintSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize ctSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                 CFRangeMake(0,0),
                                                                 NULL,
                                                                 constraintSize,
                                                                 NULL);
    KSLog(@"%s ctsize:%@",__PRETTY_FUNCTION__, NSStringFromCGSize(ctSize));
    
    
    //生成 CTFrameRef 实例
    CGPathRef path = [[self class] pathWithRect:CGRectMake(0, 0, config.width, ctSize.height)];
    CTFrameRef ctFrame = [[self class] ctFrameWithFramesetter:framesetter
                                                         path:path];
    //将 ctFrame 和计算好的绘制高度保存到 ctData 中,并将ctData返回
    KSCTData *ctData = [KSCTData data];
    ctData.ctFrame = ctFrame;
    ctData.height = ctSize.height;
    CFRelease(ctFrame);
    CFRelease(framesetter);
    KSAssert(ctData);
    return ctData;
}

/**
 *  加载配置模板,并将模板文件组装成AttributedString返回。
 *
 *  @param path          模板文件的路径
 *  @param config
 *
 *  @return attribute    NSAttributedString
 */
+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(KSCTFrameConfig *)config
                              externInfo:(id)info {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    if ([array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in array) {
            NSString *typeName = dict[@"type"];
            if ([typeName isEqualToString:@"txt"]) {
                NSAttributedString *attributedString = [self attributedStringWithDictionary:dict
                                                                                     config:config];
                [mutableAttributedString appendAttributedString:attributedString];
            } else if ([typeName isEqualToString:@"img"]) {
                if ([info isKindOfClass:[NSMutableArray class]]) {
                    KSCTImageData *imageData = [[KSCTImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = mutableAttributedString.length;
                    [(NSMutableArray *)info addObject:imageData];
                    NSAttributedString *attributedStringForImageData = [[self class] attributedStringWithImageInfo:dict config:config];
                    [mutableAttributedString appendAttributedString:attributedStringForImageData];
                }
            }
        }//for
    } else {
        KSAssert(array != nil);
    }
    return mutableAttributedString;
}

static CGFloat widthCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

static CGFloat ascentCallback(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref) {
    return 0;
}

/**
 *  <#Description#>
 *
 *  @param imageInfo <#imageInfo description#>
 *  @param config    <#config description#>
 *
 *  @return <#return value description#>
 */
+ (NSAttributedString *)attributedStringWithImageInfo:(NSDictionary *)imageInfo config:(KSCTFrameConfig *)config {
    CTRunDelegateCallbacks callback;
    memset(&callback, 0, sizeof(callback));
    callback.version = kCTRunDelegateVersion1;
    callback.getWidth = widthCallback;
    callback.getDescent = descentCallback;
    callback.getAscent = ascentCallback;
    CTRunDelegateRef ctRunDelegate = CTRunDelegateCreate(&callback, (__bridge void *)imageInfo);
    
    unichar const imagePlaceholderChar = 0xFFFC;
    NSString *string = [NSString stringWithCharacters:&imagePlaceholderChar length:1];
    NSDictionary *attributes = [[self class] attributesWithConfiguration:config];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                                attributes:attributes];
    KSAssert(ctRunDelegate);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)mutableAttributedString, CFRangeMake(0, string.length), kCTRunDelegateAttributeName, ctRunDelegate);
    CFRelease(ctRunDelegate);
    return mutableAttributedString;
}

/**
 *  解析模板文件，使用config中的属性作为默认样式
 *
 *  @param path          模板文件的路径
 *  @param config        默认样式
 *
 *  @return 返回KSCTData实例。
 */
+ (KSCTData *)dataWithTemplateFile:(NSString *)path config:(KSCTFrameConfig *)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSAttributedString *attributedString = [self loadTemplateFile:path
                                                           config:config
                                                       externInfo:imageArray];
    KSCTData *data = [self dataWithAttributedString:attributedString config:config];
    data.externInfo = imageArray;
    KSAssert(data);
    return data;
}

/**
 *  解析模板文件中的颜色
 *
 *  @param colorName 颜色名字
 *
 *  @return 返回相应的颜色
 */
+ (UIColor *)colorFromTemplate:(NSString *)colorName {
    UIColor *color = nil;
    if ([colorName isEqualToString:@"blue"]) {
        color = [UIColor blueColor];
    } else if ([colorName isEqualToString:@"red"]) {
        color = [UIColor redColor];
    } else if ([colorName isEqualToString:@"black"]) {
        color = [UIColor blackColor];
    } else if ([colorName isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    }
    return color;
}

/**
 *  解析配置
 *
 *  @param dict          配置属性
 *  @param configuration <#configuration description#>
 *
 *  @return <#return value description#>
 */
+ (NSAttributedString *)attributedStringWithDictionary:(NSDictionary *)dict
                                                config:(KSCTFrameConfig *)config {
    NSMutableDictionary *attributes = [[self class] attributesWithConfiguration:config];
    //font color
    UIColor *fontForegroundColor = [self colorFromTemplate:dict[@"color"]];
    if (fontForegroundColor) {
        attributes[(NSString *)kCTForegroundColorAttributeName] = (id)fontForegroundColor.CGColor;
    }
    //font point size
    CGFloat fontPointSize = [dict[@"size"] floatValue];
    if (fontPointSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontPointSize, NULL);
        attributes[(NSString *)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    KSAssert(content.length > 0);
    KSAssert(attributes != nil);
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}
@end

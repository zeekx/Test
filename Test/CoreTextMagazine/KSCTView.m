//
//  KSCoreTextView.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTView.h"
#import "KSCTColumnView.h"

@implementation KSCTView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupGesture];
    [self setupAppearance];
}

- (void)setupAppearance {
    self.layer.borderWidth = 0.5F;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)setupGesture {
    UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleUserTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    self.userInteractionEnabled = YES;
}

- (void)handleUserTapped:(UITapGestureRecognizer *)tap {
//    CGPoint point = [tap locationInView:self];
//    for (KSCTImageData *imageData in self.ctData.externInfo) {
//        CGRect imageRect = imageData.bounds;
//        CGPoint imagePosition = imageRect.origin;
//        imagePosition.y = self.bounds.size.height - imageRect.origin.y
//        - imageRect.size.height;
//        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
//        // 检测点击位置 point 是否在 rect 之内
//        if (CGRectContainsPoint(rect, point)) {
//            KSLog(@"bingo");
//            break;
//        }
//
//    }
}



- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(KSCTColumnView*)col
{
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    assert(imgIndex < self.images.count);
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //image in the run.
                CGRect runBounds;
                CGFloat ascent;//height above the baseline
                CGFloat descent;//height below the baseline
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + frameXOffset;
                runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + frameYOffset;
                runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                 CFDictionaryRef attributeForRun = CTRunGetAttributes(run);
                if (CFDictionaryGetCount(attributeForRun) > 0) {
                    
                } else {
                    
                }
                
                CTParagraphStyleRef paragraphStyle = (CTParagraphStyleRef)CFDictionaryGetValue(attributeForRun,kCTParagraphStyleAttributeName);
                CGFloat firstLineHeadIndent = 0;
                CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(firstLineHeadIndent), &firstLineHeadIndent);
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset - self.contentOffset.x - firstLineHeadIndent,
                                                colRect.origin.y - frameYOffset - self.frame.origin.y);
                [col.images addObject: //11
                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                 ];
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                } else {
                    return;
                }
                
            }
        }
        lineIndex++;
    }
}

- (void)buildFrames {
    frameXOffset = frameYOffset = 20;
    self.delegate = self;
    self.pagingEnabled = YES;
    
    self.ctFrames = [NSMutableArray array];
    CGMutablePathRef mutablePath = CGPathCreateMutable();

    CGRect textFrame = CGRectInset(self.bounds, frameXOffset, frameYOffset);
    KSLog(@"%s origin rect:%@",__PRETTY_FUNCTION__,NSStringFromCGRect(self.bounds));
    KSLog(@"%s new rect:%@",__PRETTY_FUNCTION__,NSStringFromCGRect(textFrame));
    CGPathAddRect(mutablePath, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    
    NSInteger   textPosition = 0;
    NSInteger   columnIndex = 0;
    CGFloat     colYOffset = 20;
    
    while (textPosition < self.attributedString.length) {
        CGPoint colOffset = CGPointMake((columnIndex + 1)*frameXOffset + columnIndex * (textFrame.size.width * 0.5), colYOffset);
        CGRect colRect = CGRectMake(0, 0, (textFrame.size.width  - frameXOffset) *.5, textFrame.size.height - colYOffset - frameYOffset);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPosition, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        KSLog(@"frame range(%@,%@)",@(frameRange.location),@(frameRange.length));
        KSCTColumnView *colView = [[KSCTColumnView alloc] initWithFrame:CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height)];
        colView.backgroundColor = [UIColor clearColor];
        
        colView.ctFrame = frame;
        colView.backgroundColor = columnIndex % 2 == 0 ? [UIColor greenColor] : [UIColor lightGrayColor];
        [self attachImagesWithFrame:frame inColumnView:colView];
        
        [self.ctFrames addObject:(__bridge id _Nonnull)(frame)];
        
        [self addSubview:colView];

        CFRelease(path);
        
        textPosition += frameRange.length;
        columnIndex ++;
    }
    NSInteger totalPages = (columnIndex + 1)/2;
    self.contentSize = CGSizeMake(totalPages * self.bounds.size.width, textFrame.size.height);
}

- (void)setAttributedString:(NSAttributedString *)attributedString withImages:(NSMutableArray *)images {
    self.attributedString = attributedString;
    self.images = images;
    CTTextAlignment textAlignment = kCTTextAlignmentJustified;
    CGFloat headIndent = 0;
    CGFloat firstLineHeadIndent = headIndent + 18;
    CGFloat lineSpacing = 6;
    CGFloat paragraphSpacing = lineSpacing * 1.618;
    CTParagraphStyleSetting settings [] = { {kCTParagraphStyleSpecifierAlignment,sizeof(textAlignment), &textAlignment},
                                            {kCTParagraphStyleSpecifierHeadIndent,sizeof(headIndent),&headIndent},
                                            {kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(firstLineHeadIndent), &firstLineHeadIndent},
                                            {kCTParagraphStyleSpecifierParagraphSpacing,sizeof(paragraphSpacing),&paragraphSpacing},
                                            {kCTParagraphStyleSpecifierLineSpacing,sizeof(lineSpacing),&lineSpacing}};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
    [mutableAttributedString addAttributes:@{(NSString *)kCTParagraphStyleAttributeName:(id)paragraphStyle}
                                     range:NSMakeRange(0, attributedString.length)];
    self.attributedString = mutableAttributedString;
}
@end

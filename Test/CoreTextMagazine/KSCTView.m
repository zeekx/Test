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
    [self setAppearance];
}


- (void)setAppearance {
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

//- (void)layoutSubviews {
//    [self setNeedsDisplay];
//    [super layoutSubviews];
//}
//
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
//    CGContextScaleCTM(context, 1.0F, -1.0F);
//    
//    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
//    CGMutablePathRef mutablePath = CGPathCreateMutable();
//    CGPathAddRect(mutablePath, NULL, self.bounds);
//    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRangeMake(0, self.attributedString.length), mutablePath, NULL);
//    
//    CTFrameDraw(ctFrame, context);
//    
//    CFRelease(mutablePath);
//    CFRelease(ctFramesetter);
//    CFRelease(ctFrame);
//}

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
        [self.ctFrames addObject:(__bridge id _Nonnull)(frame)];
        [self addSubview:colView];

        CFRelease(path);
        
        textPosition += frameRange.length;
        columnIndex ++;
    }
    NSInteger totalPages = (columnIndex + 0);
    self.contentSize = CGSizeMake(totalPages * self.bounds.size.width, textFrame.size.height);
    
}
@end

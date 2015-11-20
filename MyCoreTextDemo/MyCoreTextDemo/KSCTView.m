//
//  KSCoreTextView.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "KSCTView.h"
#import "KSCTData.h"
#import "UIView+KSCGRect.h"
#import "KSCTImageData.h"

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
    CGPoint point = [tap locationInView:self];
    for (KSCTImageData *imageData in self.ctData.externInfo) {
        CGRect imageRect = imageData.bounds;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y
        - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击位置 point 是否在 rect 之内
        if (CGRectContainsPoint(rect, point)) {
            KSLog(@"bingo");
            break;
        }

    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(context, 1.0F, -1.0F);
    
    if (self.ctData) {
        CTFrameDraw(self.ctData.ctFrame, context);
    }
    //图片替换
    for (KSCTImageData * imageData in self.ctData.externInfo) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.bounds, image.CGImage);
        }
    }
}


@end

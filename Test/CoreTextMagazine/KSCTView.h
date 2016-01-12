//
//  KSCTView.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSCTColumnView;
@interface KSCTView : UIScrollView <UIScrollViewDelegate>{
    CGFloat frameXOffset;
    CGFloat frameYOffset;
}
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *ctFrames;
@property (nonatomic, weak  ) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSMutableArray *images;
- (void)buildFrames ;
- (void)setAttributedString:(NSAttributedString *)attributedString withImages:(NSMutableArray *)images;
- (void)attachImagesWithFrame:(CTFrameRef)ctFrame inColumnView:(KSCTColumnView *)col;
@end

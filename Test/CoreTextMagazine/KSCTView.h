//
//  KSCTView.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KSCTView : UIScrollView <UIScrollViewDelegate>{
    CGFloat frameXOffset;
    CGFloat frameYOffset;
}
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *ctFrames;
@property (nonatomic, weak  ) IBOutlet NSLayoutConstraint *heightConstraint;

- (void)buildFrames ;
@end

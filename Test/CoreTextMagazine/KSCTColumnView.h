//
//  KSCTColumnView.h
//  Test
//
//  Created by yubinqiang on 15/11/21.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSCTColumnView : UIView
@property (assign, nonatomic) CTFrameRef ctFrame;
@property (strong, nonatomic) NSAttributedString *attributedString;
@property (strong, nonatomic) NSMutableArray     *images;
@end

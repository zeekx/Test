//
//  PDFPageView.h
//  PDF in Objective-C
//
//  Created by Milo on 2017/9/20.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFPageView : UIView
@property (nonatomic) CGPDFPageRef page;
@end
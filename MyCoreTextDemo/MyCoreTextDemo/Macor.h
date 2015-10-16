//
//  Macor.h
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#ifndef MyCoreTextDemo_Macor_h
#define MyCoreTextDemo_Macor_h
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#endif


#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define RGB(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]


#endif

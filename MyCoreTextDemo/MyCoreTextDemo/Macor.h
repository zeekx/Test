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


#define debugMethod()   NSLog(@"%s", __func__)
#define KSLog(...)      NSLog(__VA_ARGS__)
void assert_output(const char * szFunction, const char *szFile, int nLine, const char *szExpression);
//#define KSAssert(e) (!(e) ? assert_output(__func__, __FILE__, __LINE__, #e) : (void)0)
#define KSAssert(e) (!(e) ? assert(e) : (void)0)
#else

#define debugLog(...)
#define debugMethod()
#define KSLog(...)      ((void)0)
#define KSAssert(e)     ((void)0)

#endif

#define RGB(A, B, C)        RGBA(A,B,C,1.0)
#define RGBA(A, B, C, a)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:a]

#endif //MyCoreTextDemo_Macor_h

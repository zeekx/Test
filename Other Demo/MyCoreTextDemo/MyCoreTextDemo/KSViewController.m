//
//  KSViewController.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/11/18.
//  Copyright © 2015年 yubinqiang. All rights reserved.
//

#import "KSViewController.h"

NSString *kPreviewCoreTextSegueId = @"1";

@implementation KSViewController
- (IBAction)previewCoreText:(UIButton *)sender {
    [self performSegueWithIdentifier:kPreviewCoreTextSegueId
                              sender:self];
}

@end

//
//  CTPGCustomViewController.m
//  Test
//
//  Created by yubinqiang on 16/12/16.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CTPGCustomViewController.h"
#import "CTPGPropertyWithParaphrase.h"
#import "CTPGCustomView.h"
@interface CTPGCustomViewController ()
@property (strong, nonatomic) CTPGPropertyWithParaphrase *propertyWithParaphrase;
@end

@implementation CTPGCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.propertyWithParaphrase = [[CTPGPropertyWithParaphrase alloc] init];
    self.propertyWithParaphrase.arrayOfProperty = @[@"vi.",@"vt.",@"n"];
    self.propertyWithParaphrase.arrayOfParaphrase = @[@"走； 离开； 去做； 进行",
                                                      @"变得； 发出…声音； 成为； 处于…状态",
                                                      @"轮到的顺序； 精力； 干劲； 尝试"];
    
    CTPGCustomView *customView = (CTPGCustomView *)self.view;
    customView.propertyWithParaphrase = self.propertyWithParaphrase;
}
@end

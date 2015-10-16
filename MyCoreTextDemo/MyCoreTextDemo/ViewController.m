//
//  ViewController.m
//  MyCoreTextDemo
//
//  Created by yubinqiang on 15/7/24.
//  Copyright (c) 2015年 yubinqiang. All rights reserved.
//

#import "ViewController.h"
#import "KSCTView.h"
#import "KSCTFrameConfig.h"
#import "UIView+CGRect.h"
#import "KSCTFrameParser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet KSCTView *ctView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KSCTFrameConfig *config = [[KSCTFrameConfig alloc] init];
    config.textColor = [UIColor redColor];
    config.width    = self.ctView.width;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KSCTConfigurationDailySentence" ofType:@"plist"];
    KSCTData *ctData = [KSCTFrameParser dataWithTemplateFile:path config:config];
    self.ctView.ctData = ctData;
    self.ctView.height = ctData.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
}
@end

//
//  ViewController.m
//  CoreTextMagazine
//
//  Created by yubinqiang on 15/11/21.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import "ViewController.h"
#import "KSCoreText.h"
#import "MarkupParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)testCoreText {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"txt"];
    NSError *error = nil;
    NSString *text = [NSString stringWithContentsOfURL:url
                                              encoding:NSUTF8StringEncoding error:&error];
    KSAssert(error == nil);
    NSAttributedString *as = [[MarkupParser new] attrStringFromMarkup:text];
    KSAssert(as);
    self.ctView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.ctView.attributedString = as;
    [self.ctView buildFrames];
}

- (void)viewWillLayoutSubviews {
    [self testCoreText];
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

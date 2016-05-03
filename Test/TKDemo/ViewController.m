//
//  ViewController.m
//  TKDemo
//
//  Created by yubinqiang on 16/4/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ViewController.h"
#import "KSTextView.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet KSTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";

    
    self.textView = [[KSTextView alloc] initWithFrame:CGRectZero];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.textView];
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(_textView);
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_textView]-8-|"
                                                                     options:kNilOptions
                                                                     metrics:nil
                                                                       views:viewBindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_textView]-20-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:viewBindings]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
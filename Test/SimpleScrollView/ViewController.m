//
//  ViewController.m
//  SimpleScrollView
//
//  Created by yubinqiang on 16/6/2.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *catImage = [UIImage imageNamed:@"cat.jpg"];
    assert(catImage);
    self.imageView = [[UIImageView alloc] initWithImage:catImage];
    self.imageView.frame = CGRectMake(0, 0, catImage.size.width, catImage.size.height);
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentInset = UIEdgeInsetsMake(8, -9, 9, 10);
    self.scrollView.contentSize = catImage.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

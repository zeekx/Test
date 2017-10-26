//
//  ViewController.m
//  PDF in Objective-C
//
//  Created by Milo on 2017/9/20.
//  Copyright © 2017年 Zeek. All rights reserved.
//

#import "ViewController.h"
#import "PDFPageView.h"

@interface ViewController ()
@property(strong, nonatomic) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    Bundle.main.url(forResource: "textbook", withExtension: "pdf")
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"textbook8" withExtension:@"pdf"];
    CGPDFDocumentRef sourcePDFDocument = CGPDFDocumentRetain(CGPDFDocumentCreateWithURL((CFURLRef)url));
    CGFloat width = 1024;
    CGFloat height = 768;
    self.scrollView.frame = CGRectMake(0, 0, width, 768);
    self.scrollView.contentSize = CGSizeMake(width,height *CGPDFDocumentGetNumberOfPages(sourcePDFDocument));
    for (int i = 1; i <= CGPDFDocumentGetNumberOfPages(sourcePDFDocument); i++) {
        PDFPageView *v = [[PDFPageView alloc] initWithFrame:CGRectMake(0, height * (i-1), width, height)];
        CGPDFPageRef p = CGPDFDocumentGetPage(sourcePDFDocument, i);
//        CGPDFPageRetain(p);
        v.page = p;
//        CGPDFPageRelease(p);
        [self.scrollView addSubview:v];
    }
    CGPDFDocumentRelease(sourcePDFDocument);
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  BNResumeViewController.m
//  Test
//
//  Created by yubinqiang on 16/1/14.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "BNResumeViewController.h"

@interface BNResumeViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSURLSession *session;
@property (strong  , nonatomic) NSURLSessionDownloadTask *sessionDownloadTask;
@property (strong, nonatomic) NSData *data;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@end

@implementation BNResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"data"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cancelBarButtonItem.enabled = self.data.length == 0;
        });
    }
}
- (void)setup {
    self.data = [NSData dataWithContentsOfURL:[self path]];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _session = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration delegate:self delegateQueue:nil];
    }
    return _session;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIButton *)sender {

    [self.sessionDownloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.data = resumeData;
    }];
}

- (IBAction)start:(UIBarButtonItem *)sender {
    if (self.data.length > 0) {
        self.sessionDownloadTask = [self.session downloadTaskWithResumeData:self.data];
        [self.sessionDownloadTask resume];
        self.data = nil;
    } else if (self.sessionDownloadTask.state != NSURLSessionTaskStateRunning) {
        NSURL *url = [NSURL URLWithString:@"http://blog.oobeta.com/zb_users/upload/2013/5/2013052457128477.jpg"];
        self.sessionDownloadTask = [self.session downloadTaskWithURL:url];
            [self.sessionDownloadTask resume];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.sessionDownloadTask.state == NSURLSessionTaskStateRunning) {
        [self.sessionDownloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            if (resumeData.length > 0) {
                NSError *error = nil;
                BOOL result = [resumeData writeToURL:[self path]
                                             options:NSDataWritingWithoutOverwriting
                                               error:&error];
                assert(result && error == nil);
            }
        }];
    }
}
- (NSURL *)path {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = @"x.tmp";//[self.sessionDownloadTask.currentRequest.URL lastPathComponent];
    NSLog(@"%s %@",__PRETTY_FUNCTION__, [NSURL fileURLWithPath:[document stringByAppendingPathComponent:fileName]]);
    
    return [NSURL fileURLWithPath:[document stringByAppendingPathComponent:fileName]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - URL Session Download Delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%s Download %@ from %@ to %@  success.",__PRETTY_FUNCTION__,downloadTask.currentRequest.URL.lastPathComponent,downloadTask.currentRequest.URL,location);
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
        self.imageView.image = [UIImage imageWithData:imageData];
    });
    [session finishTasksAndInvalidate];
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s,offset:%@,expectedTotalBytes:%@",__PRETTY_FUNCTION__,@(fileOffset),@(expectedTotalBytes));
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = totalBytesWritten*100.0/totalBytesExpectedToWrite;
    NSLog(@"%s Download %@Bytes,%.2f%%",__PRETTY_FUNCTION__,@(bytesWritten),progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress/100.0 animated:YES];
    });
}
#pragma mark - Session Task Delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s error:%@",__PRETTY_FUNCTION__,error);
}
@end

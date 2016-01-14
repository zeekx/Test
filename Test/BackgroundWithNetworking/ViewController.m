//
//  ViewController.m
//  BackgroundWithNetworking
//
//  Created by yubinqiang on 15/12/29.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration delegate:self delegateQueue:nil];
    }
    return _session;
}

- (IBAction)setup {
    [self test3];
}

- (void)test1 {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"]
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions
                                                                                                       error:nil];
                                                NSLog(@"json:%@",json);
                                            }];
    [dataTask resume];
}

- (IBAction)test2:(id)sender {
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"http://blog.oobeta.com/zb_users/upload/2013/5/2013052457128477.jpg"]];
    [downloadTask resume];
}
- (void)test3 {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.allowsCellularAccess = YES;
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Accept":@"applicatin/json"};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"]
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions
                                                                                                       error:nil];
                                                NSLog(@"json:%@",json);
                                            }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - URL Session Download Delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%s Download %@ from %@ to %@  success.",__PRETTY_FUNCTION__,downloadTask.currentRequest.URL.lastPathComponent,downloadTask.currentRequest.URL,location);
    NSData *imageData = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
        self.imageView.image = [UIImage imageWithData:imageData];
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = totalBytesWritten*100.0/totalBytesExpectedToWrite;
    NSLog(@"%s Download %@Bytes,%.2f%%",__PRETTY_FUNCTION__,@(bytesWritten),progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress/100.0 animated:YES];
    });
}
@end

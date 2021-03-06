//
//  MTViewController.m
//  Test
//
//  Created by yubinqiang on 16/1/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "MTViewController.h"
#import "MyEpisodeTableViewCell.h"
#import "AppDelegate.h"

@interface MTViewController ()<MWFeedParserDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak  , nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *episodes;
@property (strong, nonatomic) MWFeedParser *feedParser;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableDictionary<NSURL *, NSNumber *> *progressBuffer;
@end

static NSString* EpisodeCell = @"EpisodeCell";
@implementation MTViewController
- (void)setPodcast:(NSDictionary *)podcast {
    if (_podcast != podcast) {
        _podcast = podcast;
        
        [self updateView];
        [self fetchAndParseFeed];
    }
}

- (NSMutableDictionary<NSURL *, NSNumber *> *)progressBuffer {
    if (_progressBuffer == nil) {
        _progressBuffer = [NSMutableDictionary dictionary];
    }
    return _progressBuffer;
}

- (NSMutableArray *)episodes {
    if (_episodes == nil) {
        _episodes = [NSMutableArray array];
    }
    return _episodes;
}

- (void)updateView {
    [self.tableView reloadData];
}

- (void)fetchAndParseFeed {
    NSURL *url = [NSURL URLWithString:[self.podcast objectForKey:@"feedUrl"]];
    if (url == nil) {
        return;
    }
    if (self.feedParser) {
        [self.feedParser stopParsing];
        [self.feedParser setDelegate:nil];
        self.feedParser = nil;
    }
    if (self.episodes) {
        self.episodes = nil;
    }
    self.feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
    [self.feedParser setFeedParseType:ParseTypeFull];
    [self.feedParser setDelegate:self];
    
    //HUB
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self.feedParser parse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.session = [self backgroundSession];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyEpisodeTableViewCell" bundle:nil] forCellReuseIdentifier:EpisodeCell];
}

- (NSURLSession *)backgroundSession {
    __block NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sc = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"TEST"];
        session = [NSURLSession sessionWithConfiguration:sc delegate:self delegateQueue:nil];
    });
    return session;
}

- (void)downloadEpisodeWithFeedItem:(MWFeedItem *)item {
    NSURL *URL = [self urlForFeedItem:item];
    if (URL) {
        [[self.session downloadTaskWithURL:URL] resume];
        [self.progressBuffer setObject:@(0) forKey:URL];
    } else {
        assert(NO);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSURL *)urlForFeedItem:(MWFeedItem *)feedItem {
    NSURL *result = nil;
    
    // Extract Enclosures
    NSArray *enclosures = [feedItem enclosures];
    if (!enclosures || !enclosures.count) return result;
    
    NSDictionary *enclosure = [enclosures objectAtIndex:0];
    NSString *urlString = [enclosure objectForKey:@"url"];
    result = [NSURL URLWithString:urlString];
    
    return result;
}

#pragma mark - Feed parser Delegate
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    if (item) {
        [self.episodes addObject:item];
        NSURL *URL = [self urlForFeedItem:item];
        NSURL *localURL = [self URLForEpisodeWithName:[URL lastPathComponent]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[localURL path]]) {
            [self.progressBuffer setObject:@(1.0) forKey:[URL absoluteString]];
        }
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.episodes ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.episodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EpisodeCell forIndexPath:indexPath];
    
    // Fetch Feed Item
    MWFeedItem *feedItem = [self.episodes objectAtIndex:indexPath.row];
    
    // Configure Table View Cell
    [cell.titleText setText:feedItem.title];
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@", feedItem.date]];
    NSURL *URL = [self urlForFeedItem:feedItem];
    cell.progressView.progress = [[self.progressBuffer objectForKey:URL] floatValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MWFeedItem *feedItem = [self.episodes objectAtIndex:indexPath.row];
    
    // URL for Feed Item
    NSURL *URL = [self urlForFeedItem:feedItem];
    if (!([[self.progressBuffer objectForKey:URL] floatValue] > 0)) {
        MWFeedItem *item  = self.episodes[indexPath.row];
        [self downloadEpisodeWithFeedItem:item];
    }
}
#pragma mark URL session delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = totalBytesWritten*100.0/totalBytesExpectedToWrite;
    NSLog(@"%s Download %@Bytes,%.2f%%",__PRETTY_FUNCTION__,@(bytesWritten),progress);
    [self.progressBuffer setObject:@(progress) forKey:downloadTask.originalRequest.URL];
    dispatch_async(dispatch_get_main_queue(), ^{
        MyEpisodeTableViewCell *cell = [self cellForForDownloadTask:downloadTask];
        [cell.progressView setProgress:progress/100.0 animated:YES];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    [self moveFile:location toNewFilePath:[self URLForEpisodeWithName:@"x.xxx"]];
    [self.progressBuffer setObject:@1 forKey:downloadTask.originalRequest.URL];
    dispatch_async(dispatch_get_main_queue(), ^{
        MyEpisodeTableViewCell *cell = [self cellForForDownloadTask:downloadTask];
        cell.progressView.hidden = YES;
    });
}
- (void)moveFile:(NSURL *)fileURL toNewFilePath:(NSURL *)url {
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:fileURL toURL:url error:&error];
//    assert(error == nil);
}

- (NSURL *)URLForEpisodeWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    return [[self episodeDirectory] URLByAppendingPathComponent:name];
}

- (NSURL *)episodeDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *document = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    assert(document);
    document = [document URLByAppendingPathComponent:@"episode"];
    if (![fm fileExistsAtPath:[document path]]) {
        NSError *error = nil;
        [fm createDirectoryAtPath:[document path] withIntermediateDirectories:YES attributes:nil error:&error
         ];
        assert(error == nil);
    }
    return document;
}

- (void)invokeBbackgroundSessionCompletionHandler {
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks,
                                                  NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks,
                                                  NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        NSUInteger countOfTasks = [dataTasks count] + [uploadTasks count] + [downloadTasks count];
        if (countOfTasks  == 0) {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            void(^backgroundSessionCompletionHandler) () = appDelegate.backgroundSessionCompletionHandler;
            if (backgroundSessionCompletionHandler) {
                appDelegate.backgroundSessionCompletionHandler = nil;
                backgroundSessionCompletionHandler();
            }
        }
    }];
}

- (MyEpisodeTableViewCell *)cellForForDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    // Helpers
    MyEpisodeTableViewCell *cell = nil;
    NSURL *URL = [[downloadTask originalRequest] URL];
    
    for (MWFeedItem *feedItem in self.episodes) {
        NSURL *feedItemURL = [self urlForFeedItem:feedItem];
        
        if ([URL isEqual:feedItemURL]) {
            NSUInteger index = [self.episodes indexOfObject:feedItem];
            cell = (MyEpisodeTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            break;
        }
    }
    
    return cell;
}

@end

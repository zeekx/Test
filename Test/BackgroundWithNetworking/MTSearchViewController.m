//
//  MTSearchViewController.m
//  Test
//
//  Created by yubinqiang on 16/1/14.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "MTSearchViewController.h"
#import "MTViewController.h"

@interface MTSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *podcasts;
@property (strong, nonatomic) NSDictionary *podcast;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@end

static NSString *SearchCell = @"SearchCell";
static NSString *MTPodcast = @"MTPodcast";

@implementation MTSearchViewController
- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [defaultConfiguration setHTTPAdditionalHeaders:@{@"Accept":@"applictaion/json"}];
        _session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    }
    return _session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:MTPodcast];
}
- (void)loadPodcast {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.podcast = [ud objectForKey:MTPodcast];
    [ud addObserver:self forKeyPath:MTPodcast options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:MTPodcast]) {
        self.podcast = [object objectForKey:MTPodcast];
    }
}
- (void)setPodcast:(NSDictionary *)podcast {
    if (_podcast != podcast) {
        _podcast = podcast;
        
        // Update View
        [self updateView];
    }
}

- (void)updateView {
    // Update View
    self.title = [self.podcast objectForKey:@"collectionName"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.podcasts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCell];
    NSDictionary *podcast = self.podcasts[indexPath.row];
    cell.textLabel.text = podcast[@"collectionName"];
    cell.detailTextLabel.text = podcast[@"artistName"];
    
    return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Podcast
    NSDictionary *podcast = [self.podcasts objectAtIndex:indexPath.row];
    
    // Update User Defatuls
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:podcast forKey:MTPodcast];
    [ud synchronize];
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MTViewController *vc  = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    vc.podcast = [self.podcasts objectAtIndex:indexPath.row];
}

- (IBAction)Cancel:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Searchbar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        return;
    } else if (searchText.length < 4){
        [self resetSearch];
    } else {
        [self performSearchWithString:searchText];
    }
}

- (void)resetSearch {
    [self.podcasts removeAllObjects];
    [self.tableView reloadData];
}
- (void)performSearchWithString:(NSString *)searchText {
    self.dataTask = [self.session dataTaskWithURL:[self urlForQuery:searchText]
                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                    if (error) {
                                        if (error.code != -999) {
                                            NSLog(@"error:%@",error);
                                        }
                                    } else {
                                        NSError *error = nil;
                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:kNilOptions
                                                                                               error:&error];
                                        NSArray *results = dict[@"results"];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (results.count > 0) {
                                                [self proseResult:results];
                                            }
                                        });
                                    }
                                }];
    [self.dataTask resume];
}

- (void)proseResult:(NSArray *)results {
    if(!self.podcasts) {
        self.podcasts= [NSMutableArray array];
    }
    
    // Update Data Source
    [self.podcasts removeAllObjects];
    [self.podcasts addObjectsFromArray:results];
    
    // Update Table View
    [self.tableView reloadData];
}
- (NSURL *)urlForQuery:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/search?media=podcast&entity=podcast&term=%@",text]];
}
@end

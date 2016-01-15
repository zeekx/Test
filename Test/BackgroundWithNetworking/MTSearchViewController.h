//
//  MTSearchViewController.h
//  Test
//
//  Created by yubinqiang on 16/1/14.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)Cancel:(UIBarButtonItem *)sender;

@end

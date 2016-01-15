//
//  MyEpisodeTableViewCell.h
//  Test
//
//  Created by yubinqiang on 16/1/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEpisodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

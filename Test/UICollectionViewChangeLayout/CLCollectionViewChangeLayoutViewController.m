//
//  CLCollectionViewChangeLayoutViewController.m
//  Test
//
//  Created by yubinqiang on 16/6/30.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "CLCollectionViewChangeLayoutViewController.h"
#import "CLCollectionViewCircleLayout.h"
#import "CLCollectionViewFlowLayout.h"
#import "CLCollectionViewCell.h"


@interface CLCollectionViewChangeLayoutViewController ()
@property (strong, nonatomic) CLCollectionViewCircleLayout *circleLayout;
@property (strong, nonatomic) CLCollectionViewFlowLayout *flowLayout;
@property (assign, nonatomic) NSUInteger                    numberOfCells;
@end

static NSString *const kCellReuseId = @"CLCollectionViewCell";

@implementation CLCollectionViewChangeLayoutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfCells = 12;
    [self setupLayout];
}

- (void)setupLayout {
    self.flowLayout = [[CLCollectionViewFlowLayout alloc] init];
    self.circleLayout = [[CLCollectionViewCircleLayout alloc] init];
    [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];
}
- (IBAction)trash:(id)sender {
    self.numberOfCells -= 1;
    [self.collectionView reloadData];
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
    if (self.collectionView.collectionViewLayout == self.flowLayout) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];
    } else {
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
    }
}

- (IBAction)add:(id)sender {
    self.numberOfCells++;
    [self.collectionView reloadData];
}

#pragma mark - Colletion view data source
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId forIndexPath:indexPath];
    cell.indexLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfCells;
}
@end

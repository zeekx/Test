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
    [self removeItem];
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
    [self.collectionView.collectionViewLayout invalidateLayout];
    if (self.collectionView.collectionViewLayout == self.circleLayout) {
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
    } else {
        [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];
    }
}

- (IBAction)add:(id)sender {
    [self addItem];
}

- (void)addItem {
    self.numberOfCells += 1;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.numberOfCells -1 inSection:0]]];
    }
                                  completion:NULL];
}

- (void)removeItem {
    if (self.numberOfCells > 0) {
        self.numberOfCells -= 1;
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.numberOfCells inSection:0]]];
        } completion:NULL];
    }
    
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

//
//  AFCollectionViewController.m
//  Test
//
//  Created by yubinqiang on 16/6/20.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "AFCollectionViewController.h"
#import "AFCollectionViewFlowLayoutCell.h"
#import "AFPhotoModel.h"
#import "AFCollectionViewHeaderView.h"

static NSString *const  kCollectionViewCellReuseId = @"AFCollectionViewFlowLayoutCell";
static NSString *const AFCollectionViewCellName = @"AFCollectionViewCell";
static NSString *const headerViewReuseId = @"AFCollectionViewHeaderView";

@interface AFCollectionViewController ()
@property (strong, nonatomic) NSArray<NSString *> *arrayOfImages;
@property (strong, nonatomic) NSArray <AFSelectionModel *> *selectionModels;
@end

@implementation AFCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupModel];
}

- (void)setupModel {
    NSMutableArray <AFSelectionModel *> *mutableSelectionModels = [NSMutableArray array];
    
    [mutableSelectionModels addObjectsFromArray:@[[AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Purple Flower" image:[UIImage imageNamed:@"0.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"WWDC Hypertable" image:[UIImage imageNamed:@"1.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Purple Flower II" image:[UIImage imageNamed:@"2.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Castle" image:[UIImage imageNamed:@"3.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Skyward Look" image:[UIImage imageNamed:@"4.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Kakabeka Falls" image:[UIImage imageNamed:@"5.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Puppy" image:[UIImage imageNamed:@"6.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Thunder Bay Sunset" image:[UIImage imageNamed:@"7.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"SUnflower I" image:[UIImage imageNamed:@"8.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Sunflower II" image:[UIImage imageNamed:@"9.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Sunflower I" image:[UIImage imageNamed:@"10.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Squirrel" image:[UIImage imageNamed:@"11.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Montréal Subway" image:[UIImage imageNamed:@"12.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Geometrically Intriguing Flower" image:[UIImage imageNamed:@"13.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Grand Lake" image:[UIImage imageNamed:@"17.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Spadina Subway Station" image:[UIImage imageNamed:@"15.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Staircase to Grey" image:[UIImage imageNamed:@"14.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Saint John River" image:[UIImage imageNamed:@"16.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Purple Bokeh Flower" image:[UIImage imageNamed:@"18.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Puppy II" image:[UIImage imageNamed:@"19.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Plant" image:[UIImage imageNamed:@"21.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Peggy's Cove I" image:[UIImage imageNamed:@"21.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Peggy's Cove II" image:[UIImage imageNamed:@"22.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Sneaky Cat" image:[UIImage imageNamed:@"23.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"King Street West" image:[UIImage imageNamed:@"24.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"TTC Streetcar" image:[UIImage imageNamed:@"25.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"UofT at Night" image:[UIImage imageNamed:@"26.jpg"]]]],
                                                  [AFSelectionModel
                                                   selectionModelWithPhotoModels:@[
                                                                                   [AFPhotoModel photoModelWithName:@"Mushroom" image:[UIImage imageNamed:@"27.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"Montréal Subway Selective Colour" image:[UIImage imageNamed:@"28.jpg"]],
                                                                                   [AFPhotoModel photoModelWithName:@"On Air" image:[UIImage imageNamed:@"29.jpg"]]]]]];
    
    self.selectionModels = mutableSelectionModels;
}

- (void)setupCollectionView {
    [self.collectionView registerClass:[AFCollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerViewReuseId];
    
}

#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.selectionModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectionModels[section].photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewFlowLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellReuseId
                                                                           forIndexPath:indexPath];
    AFSelectionModel *selectionModel = self.selectionModels[indexPath.section];
    AFPhotoModel *photoModel = selectionModel.photoModels[indexPath.row];
    cell.imageView.image = photoModel.image;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:headerViewReuseId
                                                                                 forIndexPath:indexPath];

    view.titleLabel.text = self.selectionModels[indexPath.section].photoModels.firstObject.name;

    return view;
}



#pragma mark - Datasource

#pragma mark - Delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFSelectionModel *selectionModel = self.selectionModels[indexPath.section];
    AFPhotoModel *photoModel = selectionModel.photoModels[indexPath.row];
    
    CGSize imageSize = photoModel.image.size;
    imageSize = CGSizeMake(imageSize.width * 0.1F, imageSize.height * 0.1F);
    return imageSize;
}
@end

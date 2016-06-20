//
//  AFSViewController.m
//  Survey
//
//  Created by yubinqiang on 16/6/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "ViewController.h"
#import "AFCollectionViewCell.h"
#import "AFCollectionViewHeaderView.h"
#import "AFPhotoModel.h"


@interface AFSViewController () {
    NSUInteger _currentSelectedSectionIndex;
}
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSArray<AFSelectionModel *> *selectionModels;
@end

static NSString *const reuseIdentifier = @"AFCollectionViewCell";
static NSString *const AFCollectionViewCellName = @"AFCollectionViewCell";
static NSString *const headerViewReuseId = @"AFCollectionViewHeaderView";

@implementation AFSViewController

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
    self.flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    self.flowLayout.minimumInteritemSpacing = 10.0F;
    self.flowLayout.minimumLineSpacing = 10.0F;
//    self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 20, 8);
    self.flowLayout.itemSize = CGSizeMake(112, 112/.618);
    self.flowLayout.headerReferenceSize = CGSizeMake(60, 50);
    

    [self.collectionView registerClass:[AFCollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerViewReuseId];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

#pragma mark
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX(1,MIN(self.selectionModels.count, _currentSelectedSectionIndex+1));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectionModels[section].photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    AFSelectionModel *selectionModel = self.selectionModels[indexPath.section];
    AFPhotoModel *photoModel = selectionModel.photoModels[indexPath.row];
    cell.imageView.image = photoModel.image;
    cell.selected = photoModel.isSelected;
    cell.imageNameLabel.text = photoModel.name;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        withReuseIdentifier:headerViewReuseId
                                                                               forIndexPath:indexPath];
    if (indexPath.section == 0) {
        view.text = @"Tap on a photo to start the recommendation engine.";
    } else {
        AFSelectionModel *selectionModel = self.selectionModels[indexPath.section - 1];
        NSString *selectedImageName = nil;
        for (AFPhotoModel *photoModel in selectionModel.photoModels) {
            if (photoModel.isSelected) {
                selectedImageName = photoModel.name;
                break;
            }
        }
        assert(selectedImageName.length > 0);
        view.text = [NSString stringWithFormat:@"Beause you liked %@",selectedImageName];
    }
    return view;
}

#pragma mark - Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldHighlight = YES;
    for (AFPhotoModel *model in self.selectionModels[indexPath.section].photoModels) {
        if (model.isSelected) {
            shouldHighlight = NO;
            break;
        }
    }
    return shouldHighlight;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentSelectedSectionIndex >= self.selectionModels.count-1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Recommand enginee" message:@"Test OK!" preferredStyle:UIAlertControllerStyleAlert];

        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:NULL];
        return;
    }
    self.selectionModels[indexPath.section].photoModels[indexPath.row].selected = YES;
    
    [collectionView performBatchUpdates:^{
        [collectionView insertSections:[NSIndexSet indexSetWithIndex:++_currentSelectedSectionIndex]];
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:_currentSelectedSectionIndex -1]];
    } completion:^(BOOL finished) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currentSelectedSectionIndex]
                               atScrollPosition:UICollectionViewScrollPositionTop
                                       animated:YES];
    }];
}

#pragma mark - 
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}
#pragma mark - -

@end

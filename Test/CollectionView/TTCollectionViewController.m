//
//  TTCollectionViewController.m
//  Test
//
//  Created by yubinqiang on 16/5/11.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "TTCollectionViewController.h"
#import "TTCollectionViewCell.h"


@interface TTCollectionViewController ()
@property (strong, nonatomic) NSArray<UIColor *> *colors;
@property (strong, nonatomic) NSMutableArray<NSDate *> *mutableDates;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@end

@implementation TTCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self setup];
    }
    return self;
}

- (void)setup {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"h:mm:ss a" options:kNilOptions locale:[NSLocale currentLocale]]];
//    self.flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
//    self.flowLayout.minimumInteritemSpacing = 40.0F;
//    self.flowLayout.minimumLineSpacing = 40.0F;
//    self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 20, 8);
//    self.flowLayout.itemSize = CGSizeMake(160, 100);
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TTCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TTCollectionDecorationView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"H"];
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.allowsMultipleSelection = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self setup];
//    const NSUInteger kNumberOfCell = 100;
//    NSMutableArray<UIColor *> *mutableColors = [NSMutableArray arrayWithCapacity:kNumberOfCell];
//    for (NSUInteger i = 0; i < kNumberOfCell; i++) {
//        UIColor *color = [UIColor colorWithRed:arc4random()%255/255.F
//                                         green:arc4random()%255/255.F
//                                          blue:arc4random()%255/255.F
//                                         alpha:1];
//        [mutableColors addObject:color];
//    }
//    self.colors = mutableColors;
    // Do any additional setup after loading the view.

    self.imageNames = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddButton:)];
    
}
- (void)handleAddButton:(UIBarButtonItem *)sender {
    [self addNewDate];
}

- (void)addNewDate {
    [self.collectionView performBatchUpdates:^{
        [self.mutableDates insertObject:[NSDate date] atIndex:0];
        
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageNames.count;
    return self.mutableDates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.layer.borderColor = [UIColor blueColor].CGColor;
    cell.layer.borderWidth = 0.5F;
//    cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    cell.text = [self.dateFormatter stringFromDate:[NSDate date]];
    cell.imageView.image  = [UIImage imageNamed:[@(indexPath.item).stringValue stringByAppendingString:@".jpg"]];
    return cell;
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"H" forIndexPath:indexPath];
//    return view;
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


#pragma mark - 
- (NSMutableArray<NSDate *> *)mutableDates {
    if (_mutableDates == nil) {
        _mutableDates = [NSMutableArray array];
    }
    return _mutableDates;
}
@end

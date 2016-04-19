//
//  RootViewController.m
//  PageViewController
//
//  Created by yubinqiang on 16/3/8.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "NSTextStorage+MLPages.h"


@interface RootViewController () {
    UIViewController * _tmpCurrentShowingViewController;
}

@property (readwrite, strong, nonatomic) ModelController *modelController;
#if kUseSingleLayoutManager
@property (strong, nonatomic) NSLayoutManager *layoutManager;
#else
@property (strong, nonatomic) NSLayoutManager *layoutManagerForPortrait;
@property (strong, nonatomic) NSLayoutManager *layoutManagerForLandscape;
#endif
@property (weak  , nonatomic) UIViewController *currentShowingViewController;
@end

@implementation RootViewController




#pragma mark - Lazy properties
#if kUseSingleLayoutManager
- (NSLayoutManager *)layoutManager {
    if (_layoutManager == nil) {
        _layoutManager = [[NSLayoutManager alloc] init];
    }
    return _layoutManager;
}
#else
- (NSLayoutManager *)layoutManagerForPortrait {
    if (_layoutManagerForPortrait == nil) {
        _layoutManagerForPortrait = [[NSLayoutManager alloc] init];
    }
    return _layoutManagerForPortrait;
}

- (NSLayoutManager *)layoutManagerForLandscape {
    if (_layoutManagerForLandscape == nil) {
        _layoutManagerForLandscape = [[NSLayoutManager alloc] init];
    }
    return _layoutManagerForLandscape;
}
#endif

- (ModelController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - View life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController hidesBarsOnTap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;

    CGSize size = CGRectInset(self.view.bounds, 0, 0).size;
    CGSize columnSize = CGSizeMake(roundf(size.width / [DataViewController numberOfColumnInPage]), size.height);
    self.modelController.textContainerSize = columnSize;
#if kUseSingleLayoutManager
    [self.modelController.textStorage addLayoutManager:self.layoutManager];
    self.modelController.layoutManager = self.layoutManager;
    self.modelController.numberOfColumn = [self.modelController pagesWithPageSize:columnSize];
#else
    [self.modelController.textStorage addLayoutManager:self.layoutManagerForLandscape];
    [self.modelController.textStorage addLayoutManager:self.layoutManagerForPortrait];
    self.modelController.layoutManagerForPortrait = self.layoutManagerForPortrait;
    self.modelController.layoutManagerForLandscape = self.layoutManagerForLandscape;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.modelController.numberOfColumnForLandsacpe = [self.modelController.textStorage pagesWithPageSize:columnSize];
    } else {
        self.modelController.numberOfColumnForPortait = [self.modelController.textStorage pagesWithPageSize:columnSize];
    }
#endif
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0
                                                                       currentViewController:nil
                                                                                  storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.currentShowingViewController = startingViewController;
    self.pageViewController.dataSource = self.modelController;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;
//    self.pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (self.pageViewController.transitionStyle == UIPageViewControllerTransitionStyleScroll) {
        return UIPageViewControllerSpineLocationNone;
    }

    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers.firstObject;
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.pageViewController.viewControllers.firstObject;
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}

#pragma mark - Transition
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGRect viewBounds = CGRectMake(0, 0, size.width, size.height);
    CGSize textSize = CGRectInset(viewBounds, 0, 0).size;
    
    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGSize columnSize = CGSizeMake(roundf(textSize.width / [DataViewController numberOfColumnInPage]), textSize.height);
        weakSelf.modelController.textContainerSize = columnSize;
#if kUseSingleLayoutManager
        weakSelf.modelController.numberOfColumn = [self.modelController pagesWithPageSize:columnSize];
#else
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            weakSelf.modelController.numberOfColumnForLandsacpe = [self.modelController.textStorage pagesWithPageSize:columnSize];
        } else {
            weakSelf.modelController.numberOfColumnForPortait = [self.modelController.textStorage pagesWithPageSize:columnSize];
        }
#endif

        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        if (weakSelf.modelController.numberOfPages >= 1
//            && weakSelf.modelController.currentShowingIndex == weakSelf.modelController.numberOfPages - 1) {


        DataViewController *dvc = [weakSelf.modelController viewControllerAtIndex:self.modelController.currentShowingIndex
                                                            currentViewController:nil
                                                                       storyboard:self.storyboard];
        [weakSelf.pageViewController setViewControllers:@[dvc]
                                              direction:UIPageViewControllerNavigationDirectionForward
                                               animated:NO
                                             completion:^(BOOL finished) {
//                                                 NSTextContainer *textContainer = dvc.mutableTextViews.firstObject.textContainer;
//                                                 [weakSelf.layoutManager  invalidateDisplayForGlyphRange:[weakSelf.layoutManager glyphRangeForTextContainer:textContainer]];
//                                                 [dvc updateText];
                                             }];
            
//        }
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Page view controller delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    _tmpCurrentShowingViewController = pendingViewControllers.firstObject;
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentShowingViewController = _tmpCurrentShowingViewController;
    } else {
        self.currentShowingViewController = previousViewControllers.firstObject;
    }
}
@end

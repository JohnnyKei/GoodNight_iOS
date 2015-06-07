//
//  GNSegmentViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNSegmentViewController.h"
#import "GNSegmentView.h"

@interface GNSegmentViewController ()<GNSegmentViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *contentScrollView;
@property (nonatomic)CGFloat barHeight;
@property (nonatomic, strong)GNSegmentView *segmentView;


@end

@implementation GNSegmentViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles barHeight:(CGFloat)barHeight{
    self = [super init];
    if (self) {
        
        
        _viewControllers = viewControllers;
        self.titles = titles;
        self.barBackgroundColor = RGBA(238, 238, 238, 1);
        self.titleColor = RGBA(129, 129, 129, 1);
        self.selectedTitleColor = RGBA(255,44,85, 1);
        self.indicatiorColor = RGBA(255,44,85, 1);
        self.barHeight = barHeight;
        
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat navigationBarHeight = 0;
    CGFloat statusbarHeight = 0;
    
    _segmentView = [[GNSegmentView alloc]initWithFrame:CGRectMake(0, navigationBarHeight + statusbarHeight, self.view.bounds.size.width,  _barHeight) titles:self.titles];
    _segmentView.barBackgroundColor = self.barBackgroundColor;
    _segmentView.titleColor = self.titleColor;
    _segmentView.selectedTitleColor = self.selectedTitleColor;
    _segmentView.indicatorColor = self.indicatiorColor;
    _segmentView.delegate = self;
    _segmentView.title = @"GoodNight";
    [_segmentView setBarBackgroundImage:[UIImage imageNamed:@"uber_image2"]];
    [_segmentView setBackgroundImages:@[[UIImage imageNamed:@"uber_image2"],[UIImage imageNamed:@"uber_image3"]]];
    [self.view addSubview:_segmentView];
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(_segmentView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_segmentView.bounds))];
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.bounds.size.width * _viewControllers.count, _contentScrollView.bounds.size.height);
    [self.view addSubview:_contentScrollView];
    
    for (int index = 0; index < _viewControllers.count; index ++) {
        id object = _viewControllers[index];
        if ([object isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)object;
            CGRect scrollViewRect  = _contentScrollView.bounds;
            CGRect viewFrame = CGRectMake(scrollViewRect.size.width * index, 0, scrollViewRect.size.width, scrollViewRect.size.height);
            vc.view.frame = viewFrame;
            [_contentScrollView addSubview:vc.view];
        }
    }
    
    
    [self setChildViewControllerWithIndex:0];

    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_menu_black"] style:UIBarButtonItemStylePlain target:self action:@selector(menuTapped:)];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

- (void)menuTapped:(UINavigationItem *)sender{
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)canBecomeFirstResponder{
    
    return YES;
}






#pragma mark Private Methods

- (void)setChildViewControllerWithIndex:(NSInteger)index{
    NSInteger oldIndex = _currentIndex;
    id oldObject = _viewControllers[oldIndex];
    if ([oldObject isKindOfClass:[UIViewController class]]) {
        UIViewController *oldVC = (UIViewController *)oldObject;
        [oldVC willMoveToParentViewController:self];
        [oldVC removeFromParentViewController];
        [oldVC didMoveToParentViewController:self];
    }
    
    _currentIndex = index;
    id newObject = _viewControllers[_currentIndex];
    if ([newObject isKindOfClass:[UIViewController class]]) {
        UIViewController *newVC = (UIViewController *)newObject;
        [newVC willMoveToParentViewController:self];
        [self addChildViewController:newVC];
        [newVC didMoveToParentViewController:self];
    }
    
    _segmentView.currentIndex = _currentIndex;
    
}


- (void)segmentView:(GNSegmentView *)segmentView didSelectedTitleAtIndex:(NSInteger)index{
    if (_currentIndex == index) {


    }else{
        _currentIndex = index;
        CGRect rect = _contentScrollView.bounds;
        rect.origin.x = rect.size.width * index;
        [_contentScrollView scrollRectToVisible:rect animated:YES];
        [self setChildViewControllerWithIndex:index];
    }
}






#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentIndex = scrollView.contentOffset.x / _contentScrollView.bounds.size.width;
    
    if (currentIndex == self.currentIndex) { return; }
    self.currentIndex = currentIndex;
    
    [self setChildViewControllerWithIndex:currentIndex];
    
}

@end


@implementation UIViewController (GNSegmentViewController)

@dynamic segmentViewController;

- (GNSegmentViewController *)segmentViewController{
    id containerView = self;
    
    while (![containerView isKindOfClass:[GNSegmentViewController class]] && containerView) {
        if ([containerView respondsToSelector:@selector(parentViewController)]) {
            containerView = [containerView parentViewController];
        }
    }
    
    
    return containerView;
}


@end

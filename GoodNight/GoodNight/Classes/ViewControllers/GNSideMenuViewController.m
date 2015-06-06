//
//  GNSideMenuViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNSideMenuViewController.h"


typedef NS_ENUM(NSInteger, GNSideMenuAction){
    GNSideMenuOpen,
    GNSideMenuClose
};

typedef struct {
    GNSideMenuAction menuAction;
    BOOL shouldBounce;
    CGFloat velocity;
} MVYSideMenuPanResultInfo;

@interface GNSideMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentContainerView;
@property (strong, nonatomic) UIView *menuContainerView;
@property (strong, nonatomic) UIView *opacityView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation GNSideMenuViewController

-(id)initWithMenuViewController:(UIViewController *)menuViewController
contentViewController:(UIViewController *)contentViewController{
    
    self = [super init];
    if(self){
        _menuViewController = menuViewController;
        _contentViewController = contentViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpMenuViewController:_menuViewController];
    [self setUpContentViewController:_contentViewController];
    
    [self addGestures];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark – Setters

- (void)setMenuFrame:(CGRect)menuFrame {
    
    menuFrame.origin.x = 0;
    if (menuFrame.size.height < 0) {
        menuFrame.size.height = self.view.bounds.size.height - menuFrame.origin.y;
    }
    if (menuFrame.size.width < 0) {
        menuFrame.size.width = self.view.bounds.size.width;
    }
    
    _menuFrame = menuFrame;
    
    if (_menuContainerView) {
        menuFrame.origin.x = - menuFrame.size.width;
        _menuContainerView.frame = menuFrame;
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    
    [self removeViewController:_menuViewController];
    
    _menuViewController = menuViewController;
    
    [self setUpMenuViewController:_menuViewController];
    
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    
    [self removeViewController:_contentViewController];
    
    _contentViewController = contentViewController;
    
    [self setUpContentViewController:_contentViewController];
    
}

#pragma mark – Getters

- (UIView *)contentContainerView {
    if (!_contentContainerView) {
        _contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentContainerView.backgroundColor = [UIColor clearColor];
        _contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view insertSubview:_contentContainerView atIndex:0];
    }
    
    return _contentContainerView;
}

- (UIView *)menuContainerView {
    if (!_menuContainerView) {
        if (CGRectEqualToRect(CGRectZero, self.menuFrame)) {
            self.menuFrame = CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height);
        }
        CGRect frame = self.menuFrame;
        frame.origin.x = [self closedOriginX];
        _menuContainerView = [[UIView alloc] initWithFrame:frame];
        _menuContainerView.backgroundColor = [UIColor clearColor];
        _menuContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self.view insertSubview:_menuContainerView atIndex:2];
    }
    
    return _menuContainerView;
}

#pragma mark – Public methods


- (void)closeMenu {
    
    [self closeMenuWithVelocity:0.0f];
}

- (void)openMenu {
    
    [self openMenuWithVelocity:0.0f];
}

- (void)toggleMenu {
    
    [self isMenuOpen] ? [self closeMenu] : [self openMenu];
}

- (void)disable {
    self.panGesture.enabled = NO;
}

- (void)enable {
    self.panGesture.enabled = YES;
}

- (void)changeContentViewController:(UIViewController *)contentViewController closeMenu:(BOOL)closeMenu {
    
    self.contentViewController = contentViewController;
    closeMenu ? [self closeMenu] : nil;
}

- (void)changeMenuViewController:(UIViewController *)menuViewController closeMenu:(BOOL)closeMenu {
    self.menuViewController = menuViewController;
    closeMenu ? [self closeMenu] : nil;
}

#pragma mark – Private methods

- (void)removeViewController:(UIViewController *)menuViewController {
    
    if (menuViewController) {
        [menuViewController willMoveToParentViewController:nil];
        [menuViewController.view removeFromSuperview];
        [menuViewController removeFromParentViewController];
    }
}

- (void)setUpMenuViewController:(UIViewController *)menuViewController {
    
    if (menuViewController) {
        [self addChildViewController:menuViewController];
        menuViewController.view.frame = self.menuContainerView.bounds;
        [self.menuContainerView addSubview:menuViewController.view];
        [menuViewController didMoveToParentViewController:self];
    }
}

- (void)setUpContentViewController:(UIViewController *)contentViewController {
    
    if (contentViewController) {
        [self addChildViewController:contentViewController];
        contentViewController.view.frame = self.contentContainerView.bounds;
        [self.contentContainerView addSubview:contentViewController.view];
        [contentViewController didMoveToParentViewController:self];
    }
    
}

- (UIView *)opacityView {
    
    if (!_opacityView) {
        _opacityView = [[UIView alloc] initWithFrame:self.view.bounds];
        _opacityView.backgroundColor = [UIColor blackColor];
        _opacityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _opacityView.layer.opacity = 0.0;
        
        [self.view insertSubview:_opacityView atIndex:1];
    }
    
    return _opacityView;
}

- (void)addGestures {
    
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_panGesture setDelegate:self];
        [self.view addGestureRecognizer:_panGesture];
    }
    
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        [_tapGesture setDelegate:self];
        [self.view addGestureRecognizer:_tapGesture];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    static CGRect menuFrameAtStartOfPan;
    static CGPoint startPointOfPan;
    static BOOL menuWasOpenAtStartOfPan;
    static BOOL menuWasHiddenAtStartOfPan;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            menuFrameAtStartOfPan = self.menuContainerView.frame;
            startPointOfPan = [panGesture locationInView:self.view];
            menuWasOpenAtStartOfPan = [self isMenuOpen];
            menuWasHiddenAtStartOfPan = [self isMenuHidden];
            [self.menuViewController beginAppearanceTransition:menuWasHiddenAtStartOfPan animated:YES];
            [self addShadowToMenuView];
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [panGesture translationInView:panGesture.view];
            self.menuContainerView.frame = [self applyTranslation:translation toFrame:menuFrameAtStartOfPan];
            [self applyOpacity];
            [self applyContentViewScale];
            break;
        }
            
        case UIGestureRecognizerStateEnded:{
            [self.menuViewController beginAppearanceTransition:!menuWasHiddenAtStartOfPan animated:YES];
            
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            MVYSideMenuPanResultInfo panInfo = [self panResultInfoForVelocity:velocity];
            
            if (panInfo.menuAction == GNSideMenuOpen) {
                [self openMenuWithVelocity:panInfo.velocity];
            } else {
                [self closeMenuWithVelocity:panInfo.velocity];
            }
            break;
        }
            
        default:
            break;
    }
}

- (MVYSideMenuPanResultInfo)panResultInfoForVelocity:(CGPoint)velocity {
    
    static CGFloat thresholdVelocity = 450.0f;
    CGFloat pointOfNoReturn = floorf([self closedOriginX] / 2.0f);
    CGFloat menuOrigin = self.menuContainerView.frame.origin.x;
    
    MVYSideMenuPanResultInfo panInfo = {GNSideMenuClose, NO, 0.0f};
    
    panInfo.menuAction = menuOrigin <= pointOfNoReturn ? GNSideMenuClose : GNSideMenuOpen;
    
    if (velocity.x >= thresholdVelocity) {
        panInfo.menuAction = GNSideMenuOpen;
        panInfo.velocity = velocity.x;
    } else if (velocity.x <= (-1.0f * thresholdVelocity)) {
        panInfo.menuAction = GNSideMenuClose;
        panInfo.velocity = velocity.x;
    }
    
    return panInfo;
}

- (BOOL)isMenuOpen {
    return self.menuContainerView.frame.origin.x == 0.0f;
}

- (BOOL)isMenuHidden {
    return self.menuContainerView.frame.origin.x <= [self closedOriginX];
}

- (CGFloat)closedOriginX {
    return - self.menuFrame.size.width;
}

- (CGRect)applyTranslation:(CGPoint)translation toFrame:(CGRect)frame {
    
    CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = [self closedOriginX];
    CGFloat maxOrigin = 0.0f;
    CGRect newFrame = frame;
    
    if (newOrigin < minOrigin) {
        newOrigin = minOrigin;
    } else if (newOrigin > maxOrigin) {
        newOrigin = maxOrigin;
    }
    
    newFrame.origin.x = newOrigin;
    return newFrame;
}

- (CGFloat)getOpenedMenuRatio {
    
    CGFloat currentPosition = self.menuContainerView.frame.origin.x - [self closedOriginX];
    return currentPosition / self.menuFrame.size.width;
}

- (void)applyOpacity {
    
    CGFloat openedMenuRatio = [self getOpenedMenuRatio];
    CGFloat opacity = 1 * openedMenuRatio;
    self.opacityView.layer.opacity = opacity;
}

- (void)applyContentViewScale {
    
    CGFloat openedMenuRatio = [self getOpenedMenuRatio];
    CGFloat scale = 1.0 - ((1.0 - 1) * openedMenuRatio);
    
    [self.contentContainerView setTransform:CGAffineTransformMakeScale(scale, scale)];
}

- (void)openMenuWithVelocity:(CGFloat)velocity {
    
    CGFloat menuXOrigin = self.menuContainerView.frame.origin.x;
    CGFloat finalXOrigin = 0.0f;
    
    CGRect frame = self.menuContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration;
    if (velocity == 0.0f) {
        duration = 0.4;
    } else {
        duration = fabs(menuXOrigin - finalXOrigin) / velocity;
        duration = fmax(0.1, fmin(1.0f, duration));
    }
    
    [self addShadowToMenuView];
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuContainerView.frame = frame;
        self.opacityView.layer.opacity = 1;

    } completion:^(BOOL finished) {
        [self disableContentInteraction];
    }];
}

- (void)closeMenuWithVelocity:(CGFloat)velocity {
    
    CGFloat menuXOrigin = self.menuContainerView.frame.origin.x;
    CGFloat finalXOrigin = [self closedOriginX];
    
    CGRect frame = self.menuContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration;
    if (velocity == 0.0f) {
        duration = 0.4;
    } else {
        duration = fabs(menuXOrigin - finalXOrigin) / velocity;
        duration = fmax(0.1, fmin(1.0f, duration));
    }
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuContainerView.frame = frame;
        
        DLog(@"%@",NSStringFromCGRect(self.menuFrame));
        DLog(@"%@",NSStringFromCGRect(self.menuContainerView.frame));
        self.opacityView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [self removeMenuShadow];
        [self enableContentInteraction];
    }];
}

- (BOOL)slideMenuForGestureRecognizer:(UIGestureRecognizer *)gesture withTouchPoint:(CGPoint)point {
    
    BOOL slide = [self isMenuOpen];
    
    slide |= [self isPointContainedWithinBezelRect:point];
    
    slide |= [self isPointContainedWithinNavigationRect:point];
    
    return slide;
}

-(BOOL)isPointContainedWithinNavigationRect:(CGPoint)point {
    CGRect navigationBarRect = CGRectNull;
    if([self.contentViewController isKindOfClass:[UINavigationController class]]){
        UINavigationBar * navBar = [(UINavigationController*)self.contentViewController navigationBar];
        navigationBarRect = [self.contentViewController.view convertRect:navBar.frame toView:self.view];
        navigationBarRect = CGRectIntersection(navigationBarRect,self.view.bounds);
    }
    return CGRectContainsPoint(navigationBarRect,point);
}

-(BOOL)isPointContainedWithinBezelRect:(CGPoint)point {
    CGRect leftBezelRect;
    CGRect tempRect;
    CGFloat bezelWidth = 40;
    
    CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, bezelWidth, CGRectMinXEdge);
    
    return CGRectContainsPoint(leftBezelRect, point);
}

- (BOOL)isPointContainedWithinMenuRect:(CGPoint)point {
    return CGRectContainsPoint(self.menuContainerView.frame, point);
}

- (void)addShadowToMenuView {
    
    self.menuContainerView.layer.masksToBounds = NO;
    self.menuContainerView.layer.shadowOffset = CGSizeMake(5, 5);
    self.menuContainerView.layer.shadowOpacity = 0.8;
    self.menuContainerView.layer.shadowRadius = 2.0;
    self.menuContainerView.layer.shadowPath = [[UIBezierPath
                                                bezierPathWithRect:self.menuContainerView.bounds] CGPath];
}

- (void)removeMenuShadow {
    
    self.menuContainerView.layer.masksToBounds = YES;
    self.contentContainerView.layer.opacity = 1.0;
}

- (void)removeContentOpacity {
    self.opacityView.layer.opacity = 0.0;
}

- (void)addContentOpacity {
    self.opacityView.layer.opacity = 0.8;
}

- (void)disableContentInteraction {
    [self.contentContainerView setUserInteractionEnabled:NO];
}

- (void)enableContentInteraction {
    [self.contentContainerView setUserInteractionEnabled:YES];
}

#pragma mark – UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self.view];
    
    if (gestureRecognizer == _panGesture) {
        return [self slideMenuForGestureRecognizer:gestureRecognizer withTouchPoint:point];
    } else if (gestureRecognizer == _tapGesture){
        return [self isMenuOpen] && ![self isPointContainedWithinMenuRect:point];
    }
    
    return YES;
}


@end


@implementation UIViewController (GNSideMenuViewController)

- (GNSideMenuViewController *)sideMenuController {
    
    UIViewController *viewController = self;
    
    while (viewController) {
        if ([viewController isKindOfClass:[GNSideMenuViewController class]])
            return (GNSideMenuViewController *)viewController;
        
        viewController = viewController.parentViewController;
    }
    return nil;
}


- (void)toggleMenu {
    
    [[self sideMenuController] toggleMenu];
}

@end
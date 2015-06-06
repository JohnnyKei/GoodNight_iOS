//
//  GNSideMenuViewController.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNSideMenuViewController : UIViewController

- (instancetype)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController;

- (void)closeMenu;

- (void)openMenu;

- (void)toggleMenu;

- (void)disable;

- (void)enable;


- (void)changeContentViewController:(UIViewController *)contentViewController closeMenu:(BOOL)closeMenu;


@property (nonatomic, assign) CGRect menuFrame;


@end



@interface UIViewController (GNSideMenuViewController)
- (GNSideMenuViewController *)sideMenuController;
@end
//
//  GNSegmentViewController.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNSegmentViewController : UIViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles barHeight:(CGFloat)barHeight;


@property (nonatomic, strong)UIColor *indicatiorColor;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIColor *selectedTitleColor;
@property (nonatomic, strong)UIColor *barBackgroundColor;
@property (nonatomic, strong)NSArray *viewControllers;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic)NSInteger currentIndex;
@property (nonatomic, strong)UIImage *barBackgroundImage;


@end


@interface UIViewController (GNSegmentViewController)

@property (nonatomic, readonly)GNSegmentViewController *segmentViewController;

@end

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

@end

//
//  GNSegmentView.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GNSegmentView;

@protocol GNSegmentViewDelegate <NSObject>

@required
- (void)segmentView:(GNSegmentView *)segmentView didSelectedTitleAtIndex:(NSInteger)index;


@end

@interface GNSegmentView : UIView

@property (nonatomic, weak)id<GNSegmentViewDelegate>delegate;
@property (nonatomic, strong)UIColor *indicatorColor;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIColor *selectedTitleColor;
@property (nonatomic, strong)UIColor *barBackgroundColor;
@property (nonatomic, strong)UIImage *barBackgroundImage;
@property (nonatomic, strong)NSString *title;
@property (nonatomic)NSInteger currentIndex;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end

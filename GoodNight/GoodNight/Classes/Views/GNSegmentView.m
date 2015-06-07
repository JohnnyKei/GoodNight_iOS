//
//  GNSegmentView.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNSegmentView.h"

@interface GNSegmentView ()

@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *items;
@property (nonatomic, strong)UIView *indicatorView;
@property (nonatomic)CGFloat itemWidth;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView *imageCoverView;
@end

const CGFloat kIndicatorHeight = 2.0;

@implementation GNSegmentView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        _imageCoverView = [[UIView alloc]initWithFrame:_imageView.bounds];
        [_imageView addSubview:_imageCoverView];
        _imageCoverView.backgroundColor = RGBA(16, 18, 36, 1);
        _imageCoverView.alpha = 0;
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
        _titleLabel.center = self.center;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
    
        
        _titles = titles;
        CGFloat itemWidth = frame.size.width / titles.count;
        _itemWidth = itemWidth;
        CGFloat itemHeight = frame.size.height;
        NSMutableArray *mArray = [NSMutableArray array];
        for (int index = 0; index < titles.count; index++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(itemWidth * index, itemHeight - 44, itemWidth, 44)];
            [button setTitle:_titles[index] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button setTag:index];
            [button addTarget:self action:@selector(didSelectTitle:) forControlEvents:UIControlEventTouchUpInside];
            if (index == 0) {
                button.selected = YES;
            }
            [self addSubview:button];
            [mArray addObject:button];
        }
        
        _items = [NSArray arrayWithArray:mArray];
        
        
        
        _indicatorView= [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - kIndicatorHeight - 5, _itemWidth, kIndicatorHeight)];
        _indicatorView.backgroundColor = [UIColor blueColor];
        [self addSubview:_indicatorView];
        
    
        
    }
    return self;
}


#pragma mark Setters

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    for (UIButton *button in _items) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    _titleLabel.textColor = titleColor;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = selectedTitleColor;
    for (UIButton *button in _items) {
        [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    NSInteger oldIndex = _currentIndex;
    UIButton *old = _items[oldIndex];
    old.selected = NO;
    _currentIndex = currentIndex;
    UIButton *btn = _items[currentIndex];
    btn.selected = YES;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.frame = CGRectMake(_itemWidth * _currentIndex, self.bounds.size.height - kIndicatorHeight - 5, _itemWidth, kIndicatorHeight);
    }];
    
    if (self.backgroundImages) {
        self.barBackgroundImage = self.backgroundImages[currentIndex];
    }
    self.imageCoverView.alpha = 1.0;

    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageCoverView.alpha = 0.0;

    } completion:^(BOOL finished) {
     
    }];
    
}


- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor{
    _barBackgroundColor = barBackgroundColor;
    self.backgroundColor = barBackgroundColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}


- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage{
    _barBackgroundImage = barBackgroundImage;
    self.barBackgroundColor = [UIColor clearColor];
    self.imageView.image = barBackgroundImage;
    
}



- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark Actions


- (void)didSelectTitle:(UIButton *)sender{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(segmentView:didSelectedTitleAtIndex:)]) {
        [self.delegate segmentView:self didSelectedTitleAtIndex:sender.tag];
    
    }
    
}


- (void)setIndicatorViewFrameWithRatio:(CGFloat)ratio{
    
    CGFloat originX = 0.0;
    
    _indicatorView.frame = CGRectMake(originX, self.bounds.size.height - kIndicatorHeight, _itemWidth, kIndicatorHeight);
    
    
}




@end

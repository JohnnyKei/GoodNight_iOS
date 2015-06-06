//
//  GNHotelCell.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNHotelCell.h"

@interface GNHotelCell ()

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UIView *cardView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *addressLabel;

@end


const CGFloat kCardHeightMargin = 3.0;
const CGFloat kCardWidthMargin = 6.0;

@implementation GNHotelCell


- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}




- (void)commonInit{
    self.cardView = [UIView new];
    [self.cardView.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.cardView.layer setShadowOpacity:0.3];
    [self.cardView.layer setShadowRadius:1];
    [self addSubview:self.cardView];
    
    self.iconImageView = [UIImageView new];
    [self.cardView addSubview:self.iconImageView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.cardView addSubview:self.nameLabel];
    
    self.addressLabel= [UILabel new];
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    [self.cardView addSubview:self.addressLabel];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.cardView.frame = CGRectMake(kCardWidthMargin, kCardHeightMargin, self.bounds.size.width - kCardWidthMargin *2 , self.bounds.size.height - kCardHeightMargin * 2);
    [self.cardView.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.cardView.bounds].CGPath];
    self.iconImageView.frame = CGRectMake(5, (self.cardView.frame.size.height - 44)/2, 44, 44);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame), 2, 200, 22);
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame), 2 + 22 +2, 200, 22);
    
}


- (void)setHotel:(GNHotel *)hotel{
    _hotel = hotel;
    self.nameLabel.text = hotel.name;
    self.addressLabel.text = hotel.address;
}

- (void)setCardColor:(UIColor *)cardColor{
    self.cardView.backgroundColor = cardColor;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc{
    self.cardView = nil;
    
}

@end

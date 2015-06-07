//
//  GNHotelDetailViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNHotelDetailViewController.h"
#import "GNApiMnager.h"
#import "GNDetailHotel.h"
#import "GNWaitingViewController.h"

@interface GNHotelDetailViewController ()<UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)GNHotel *hotel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *checkLabel;
@property (nonatomic, strong)UILabel *descriptionLabel;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *check;
@property (nonatomic, strong)UILabel *checkInLabel;
@property (nonatomic, strong)UILabel *checkOutLabel;
@property (nonatomic, strong)UILabel *checkInDateLabel;
@property (nonatomic, strong)UILabel *checkOutDateLabel;

@property (nonatomic, strong)UIButton *reserveButton;

//@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)GNDetailHotel *detailHotel;

@end

@implementation GNHotelDetailViewController


- (instancetype)initWithHotel:(GNHotel *)hotel{
    self = [super init];
    if (self) {
        _hotel = hotel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(19, 18, 36, 1);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = RGBA(19, 18, 36, 1);
    [self.view addSubview:_scrollView];

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    
    _reserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reserveButton setFrame:CGRectMake(_imageView.frame.size.width - 60 - 10, _imageView.frame.size.height - 32 -10, 60, 32)];
    [_reserveButton setTitle:@"予約" forState:UIControlStateNormal];
    [_reserveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reserveButton setBackgroundColor:RGBA(30, 186, 214, 1)];
    [_reserveButton.layer setShadowRadius:2];
    [_reserveButton.layer setShadowPath:[UIBezierPath bezierPathWithRect:_reserveButton.bounds].CGPath];
    [_reserveButton.layer setShadowOpacity:0.7];
    [_reserveButton.layer setShadowOffset:CGSizeMake(1, 1)];
    [_reserveButton addTarget:self action:@selector(reserveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _reserveButton.alpha = 0;
    [_imageView addSubview:_reserveButton];
    
    _nameLabel = [[UILabel alloc]init];
    
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _nameLabel.textColor = [UIColor whiteColor];
    [_imageView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.font = [UIFont systemFontOfSize:13];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.numberOfLines = 0;
    [_scrollView addSubview:_addressLabel];
    
    _descriptionLabel = [[UILabel alloc]init];
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    _descriptionLabel.textColor = [UIColor whiteColor];
    _descriptionLabel.numberOfLines = 0;
    [_scrollView addSubview:_descriptionLabel];
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.font = [UIFont systemFontOfSize:13];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.numberOfLines = 0;
    [_scrollView addSubview:_phoneLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedPhoneCall:)];
    [_phoneLabel addGestureRecognizer:tap];
    
    
    _check = [[UILabel alloc]init];
    _check.font = [UIFont systemFontOfSize:13];
    _check.textColor = [UIColor whiteColor];
    _check.textAlignment = NSTextAlignmentCenter;
    _check.numberOfLines = 0;
    [_scrollView addSubview:_check];
    
    _checkInLabel = [[UILabel alloc]init];
    _checkInLabel.font = [UIFont systemFontOfSize:13];
    _checkInLabel.textColor = [UIColor whiteColor];
    _checkInLabel.textAlignment = NSTextAlignmentCenter;
    _checkInLabel.numberOfLines = 0;
    [_scrollView addSubview:_checkInLabel];
    
    
    _checkOutLabel = [[UILabel alloc]init];
    _checkOutLabel.font = [UIFont systemFontOfSize:13];
    _checkOutLabel.textColor = [UIColor whiteColor];
    _checkOutLabel.textAlignment = NSTextAlignmentCenter;
    _checkOutLabel.numberOfLines = 0;
    [_scrollView addSubview:_checkOutLabel];
    
    _checkInDateLabel = [[UILabel alloc]init];
    _checkInDateLabel.font = [UIFont systemFontOfSize:13];
    _checkInDateLabel.textColor = [UIColor whiteColor];
    _checkInDateLabel.textAlignment = NSTextAlignmentCenter;
    _checkInDateLabel.numberOfLines = 0;
    [_scrollView addSubview:_checkInDateLabel];
    
    _checkOutDateLabel = [[UILabel alloc]init];
    _checkOutDateLabel.font = [UIFont systemFontOfSize:13];
    _checkOutDateLabel.textAlignment = NSTextAlignmentCenter;
    _checkOutDateLabel.numberOfLines = 0;
    [_scrollView addSubview:_checkOutDateLabel];
    
    
    
    
    [self callApi];
    
    // Do any additional setup after loading the view.
}


- (void)callApi{
    [SVProgressHUD show];
    __weak typeof(self) weakself = self;
    [[GNApiMnager sharedManager] getRequest:self.hotel.detailURL params:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        DLog(@"%@",responseObject);
        [weakself setDetail:responseObject];
        
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
    }];
}

- (void)setDetail:(NSDictionary *)dictionary{
    _detailHotel = [[GNDetailHotel alloc]initWithDictionary:dictionary];
//    [self.tableView reloadData];
    [self reloadData];
}

- (void)reserveButtonTapped:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"ホテルを予約しUberを呼びました。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 11;
    [alert show];
}


- (void)tappedPhoneCall:(UITapGestureRecognizer *)tapGesture{
    DLog(@"PHONE");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@に電話をしますか？",self.detailHotel.tel] delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"電話", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        GNWaitingViewController *vc = [[GNWaitingViewController alloc]initWithDetailHotel:self.detailHotel];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)reloadData{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.detailHotel.imageURL] placeholderImage:[UIImage imageNamed:@"no_image"]];
    
    self.nameLabel.frame = CGRectMake(5, _imageView.bounds.size.height - 30, self.view.bounds.size.width - 5 *2 - 60, 20);
    self.nameLabel.text = self.detailHotel.name;
    
    
    _reserveButton.alpha = 1;
    
    CGRect originRect =CGRectMake(5, CGRectGetMaxY(_imageView.frame) + 10, self.view.bounds.size.width - 10, 300);
    self.descriptionLabel.frame = originRect;
    self.descriptionLabel.text = self.detailHotel.hotelDescription;
    [self.descriptionLabel sizeToFit];
    originRect.size.height = self.descriptionLabel.frame.size.height;
    self.descriptionLabel.frame = originRect;
    
    DLog(@"%@",NSStringFromCGRect(originRect));
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.descriptionLabel.frame) + 10, self.view.bounds.size.width, 0.5)];
    line1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:line1];
    
    originRect = CGRectMake(5, CGRectGetMaxY(line1.frame) + 10, self.view.bounds.size.width - 5 *2, 70);
    self.addressLabel.frame = originRect;
    self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@",self.detailHotel.area,self.detailHotel.address];
    [self.addressLabel sizeToFit];
    originRect.size.height = self.addressLabel.frame.size.height;
    self.addressLabel.frame = originRect;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressLabel.frame) + 10, self.view.bounds.size.width, 0.5)];
    line2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:line2];
    
    originRect = CGRectMake(5, CGRectGetMaxY(line2.frame) + 10, self.view.bounds.size.width - 5 *2, 70);
    self.phoneLabel.frame = originRect;
    self.phoneLabel.text = [NSString stringWithFormat:@"電話する\n%@",self.detailHotel.tel];
    [self.phoneLabel sizeToFit];
    originRect.size.height = self.phoneLabel.frame.size.height;
    self.phoneLabel.frame = originRect;
    
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneLabel.frame) + 10, self.view.bounds.size.width, 0.5)];
    line3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:line3];
    
    
    originRect = CGRectMake(5, CGRectGetMaxY(line3.frame) + 10, self.view.bounds.size.width - 5 *2, 20);
    self.check.frame = originRect;
    self.check.text = [NSString stringWithFormat:@"チェックイン/チェックアウト"];
    [self.check sizeToFit];
    originRect.size.height = self.check.frame.size.height;
    self.check.frame = originRect;
    
    originRect = CGRectMake((self.view.bounds.size.width/2 - 100)/2, CGRectGetMaxY(self.check.frame) + 10, 100, 20);
    self.checkInLabel.frame = originRect;
    self.checkInLabel.text = [NSString stringWithFormat:@"チェックイン"];
    [self.checkInLabel sizeToFit];
    originRect.size.height = self.checkInLabel.frame.size.height;
    self.checkInLabel.frame = originRect;
    
    originRect = CGRectMake((self.view.bounds.size.width/2 - 100)/2, CGRectGetMaxY(self.checkInLabel.frame) + 5, 100, 20);
    self.checkInDateLabel.frame = originRect;
//    self.checkInDateLabel.text = [self stringFromDate:self.detailHotel.checkIn];
    [self.checkInDateLabel sizeToFit];
    originRect.size.height = self.checkInDateLabel.frame.size.height;
    self.checkInDateLabel.frame = originRect;
    
    originRect = CGRectMake(self.view.bounds.size.width/2 + (self.view.bounds.size.width/2 - 100)/2, CGRectGetMaxY(self.check.frame) + 10, 100, 20);
    self.checkOutLabel.frame = originRect;
    self.checkOutLabel.text = [NSString stringWithFormat:@"チェックアウト"];
    [self.checkOutLabel sizeToFit];
    originRect.size.height = self.checkOutLabel.frame.size.height;
    self.checkOutLabel.frame = originRect;
    
    originRect = CGRectMake(self.view.bounds.size.width/2 + (self.view.bounds.size.width/2 - 100)/2, CGRectGetMaxY(self.checkOutLabel.frame) + 5, 100, 20);
    self.checkOutDateLabel.frame = originRect;
//    self.checkOutDateLabel.text = [self stringFromDate:self.detailHotel.checkOut];
    [self.checkOutDateLabel sizeToFit];
    originRect.size.height = self.checkOutDateLabel.frame.size.height;
    self.checkOutDateLabel.frame = originRect;
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.checkOutDateLabel.frame) + 10, self.view.bounds.size.width, 0.5)];
    line4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:line4];
    
    
    
}


- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //タイムゾーンの指定
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60 * 60 * 9]];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    NSLog(@"date: %@",date);
    return date;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = RGBA(19, 18, 36, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

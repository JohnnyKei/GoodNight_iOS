//
//  GNHotelDetailViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNHotelDetailViewController.h"
#import "GNApiMnager.h"

@interface GNHotelDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)GNHotel *hotel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *checkLabel;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.view addSubview:_imageView];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_imageView.frame), 300, 100)];
//    _nameLabel.text = self.hotel.name;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [_nameLabel sizeToFit];
    [self.view addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_nameLabel.frame), 300, 100)];
    _addressLabel.font = [UIFont systemFontOfSize:13];
//    _addressLabel.text = self.hotel.address;
    [self.view addSubview:_addressLabel];
    

    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

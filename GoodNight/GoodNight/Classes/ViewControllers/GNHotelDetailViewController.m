//
//  GNHotelDetailViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNHotelDetailViewController.h"

@interface GNHotelDetailViewController ()

@property (nonatomic, strong)GNHotel *hotel;


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
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.view addSubview:imageView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame), 300, 100)];
    nameLabel.text = self.hotel.name;
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(nameLabel.frame), 300, 100)];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.text = self.hotel.address;
    [self.view addSubview:addressLabel];
                                                            
    
    
    
    // Do any additional setup after loading the view.
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

//
//  GDHotelListViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNHotelListViewController.h"
#import "GNHotelDetailViewController.h"
#import "GNHotelCell.h"
#import "GNApiMnager.h"
#import "GNLoginViewController.h"

@interface GNHotelListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *hotelList;
@property (nonatomic, assign)BOOL loginShow;

@end

@implementation GNHotelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[GNHotelCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _hotelList = [NSMutableArray array];
    
    [self callApi];
    
    
    self.loginShow = NO;
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.loginShow == NO) {
//        GNLoginViewController *loginVC = [[GNLoginViewController alloc]init];
//        [self.segmentViewController presentViewController:loginVC animated:NO completion:^{
//            self.loginShow = YES;
//        }];
//    }

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GNHotelCell *cell = (GNHotelCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[GNHotelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.cardColor = [UIColor whiteColor];
    GNHotel *hotel = self.hotelList[indexPath.row];
    [cell setHotel:hotel];
    return cell;
    
//    |
    
    
}

- (void)callApi{
    [SVProgressHUD show];
    __weak typeof(self) weakself = self;
    [[GNApiMnager sharedManager] getRequest:@"https://goodnight.herokuapp.com/hotels.json" params:nil success:^(id responseObject) {
        DLog(@"res:%@",responseObject);
        NSArray *response = (NSArray *)responseObject;
        for (NSDictionary *dic in response) {
            GNHotel *hotel = [[GNHotel alloc]initWithDictionary:dic];
            [weakself.hotelList addObject:hotel];
        }
        [weakself.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GNHotel *selectedHotel = self.hotelList[indexPath.row];
    
    
    GNHotelDetailViewController *hotelDetailVC = [[GNHotelDetailViewController alloc]initWithHotel:selectedHotel];
    [[self segmentViewController].navigationController pushViewController:hotelDetailVC animated:YES];
    
    
}

@end

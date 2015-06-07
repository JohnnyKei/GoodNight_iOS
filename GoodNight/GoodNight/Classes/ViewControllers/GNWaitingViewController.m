//
//  GNWaitingViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNWaitingViewController.h"
#import "GNApiMnager.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GNWaitingViewController ()<CLLocationManagerDelegate, GMSMapViewDelegate>

@property (nonatomic, strong)GMSMapView *mapView;
@property (nonatomic, strong)GNDetailHotel *detailHotel;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)CLLocation *currentLocation;
@property (nonatomic, strong)UIButton *currentButton;

@end

@implementation GNWaitingViewController


- (instancetype)initWithDetailHotel:(GNDetailHotel *)detailHotel{
    self = [super init];
    if (self) {
        _detailHotel = detailHotel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.6773896
                                                            longitude:139.7217769
                                                                 zoom:14];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    self.view = _mapView;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    // Creates a marker in the center of the map.
    
    
    _currentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _currentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleTopMargin;
    [_currentButton setBackgroundColor:[UIColor whiteColor]];
    [_currentButton setFrame:CGRectMake(_mapView.frame.size.width - 50 -10, _mapView.frame.size.height - 50 -10, 50, 50)];
    //    [_currentButton setFrame:CGRectMake(0, 0, 60, 60)];
    [_currentButton.layer setCornerRadius:50/2];
    [_currentButton.layer setShadowOpacity:0.8];
    [_currentButton.layer setShadowPath:[UIBezierPath bezierPathWithOvalInRect:_currentButton.bounds].CGPath];
    [_currentButton.layer setShadowRadius:3];
    [_currentButton.layer setShadowOffset:CGSizeMake(2, 2)];
    [_currentButton setImage:[UIImage imageNamed:@"ic_place_small"] forState:UIControlStateNormal];
    [_currentButton addTarget:self action:@selector(currentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_currentButton];
    
    
    
    [self initLocationManager];
    
    [self start];

    [self callApi];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)callApi{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [ud objectForKey:UBER_ACCESS_TOKEN];
    DLog(@"%@",accessToken);
    if (accessToken) {
        NSString *str = [NSString stringWithFormat:@"%@/v1/products",UBER_BASE_API];
        [[GNApiMnager sharedManager]getHTTPRequest:str
                                        params:@{@"latitude":@(_detailHotel.latitude),
                                                 @"longitude":@(_detailHotel.longitude),
                                                 }
                                       success:^(id responseObject) {
                                           DLog(@"res %@",responseObject);
        }
                                       failure:^(NSError *error) {
                                           DLog(@"error:%@",error);
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initLocationManager{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)currentButtonTapped:(id)sender{
    [self start];
}


- (void)setCurrentLocation:(CLLocation *)currentLocation{
    _currentLocation = currentLocation;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:14];
    [_mapView moveCamera:[GMSCameraUpdate setCamera:camera]];
    
    [self callApi];
    
    
}

- (void)start{
    // 位置情報サービスが使えないとき
    if ([CLLocationManager locationServicesEnabled] == NO) {
        [self locationManager:nil didFailWithError:[NSError errorWithDomain:@"LocationServices disabled" code:1 userInfo:nil]];
        return;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                DLog(@"notDeterMined");
                [self.locationManager requestWhenInUseAuthorization];
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                DLog(@"start");
                
                [self.locationManager startUpdatingLocation];
                
                DLog(@"%@",self.locationManager);
                break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                DLog(@"error");
                
                [self locationManager:self.locationManager didFailWithError:[NSError errorWithDomain:@"Location Authorization Denied" code:1 userInfo:nil]];
                break;
        }
    }
    // iOS7未満
    else {
        [self.locationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    DLog(@"update");
    self.currentLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self locationManager:self.locationManager didFailWithError:[NSError errorWithDomain:@"Location Authorization Denied" code:1 userInfo:nil]];
            break;
    }
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

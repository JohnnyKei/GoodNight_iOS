//
//  GNMapViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "GNApiMnager.h"
#import "GNHotel.h"
#import "GNHotelDetailViewController.h"
@interface GNMapViewController ()<CLLocationManagerDelegate, GMSMapViewDelegate>

@property (nonatomic, strong)GMSMapView *mapView;

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)CLLocation *currentLocation;
@property (nonatomic, strong)UIButton *currentButton;
@property (nonatomic, strong)NSMutableArray *hotelList;

@end

@implementation GNMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

    
    _hotelList = [NSMutableArray array];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)setCurrentLocation:(CLLocation *)currentLocation{
    _currentLocation = currentLocation;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:14];
    [_mapView moveCamera:[GMSCameraUpdate setCamera:camera]];
    
    
}



- (void)callApi{
    [SVProgressHUD show];
    __weak typeof(self) weakself = self;
    [weakself.hotelList removeAllObjects];
    
    [[GNApiMnager sharedManager] getRequest:@"https://goodnight.herokuapp.com/hotels.json" params:nil success:^(id responseObject) {
        DLog(@"res:%@",responseObject);
        NSArray *response = (NSArray *)responseObject;
        for (NSDictionary *dic in response) {
            GNHotel *hotel = [[GNHotel alloc]initWithDictionary:dic];
            [weakself.hotelList addObject:hotel];
        }
        [SVProgressHUD dismiss];
        [weakself reloadPins];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)reloadPins{
    for (GNHotel *hotel in _hotelList) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(hotel.latitude, hotel.longitude);
        marker.title = hotel.name;
        marker.userData = hotel;
        marker.map = _mapView;
    }
}



- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    GNHotel *selectedHotel = (GNHotel *)marker.userData;
    GNHotelDetailViewController *hotelDetailVC = [[GNHotelDetailViewController alloc]initWithHotel:selectedHotel];
    [[self segmentViewController].navigationController pushViewController:hotelDetailVC animated:YES];}

@end

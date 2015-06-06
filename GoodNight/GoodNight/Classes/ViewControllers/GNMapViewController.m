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

@interface GNMapViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong)GMSMapView *mapView;

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)CLLocation *currentLocation;

@end

@implementation GNMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.6668525
                                                            longitude:139.692626
                                                                 zoom:10];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.myLocationEnabled = YES;
    self.view = _mapView;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(35.6668525, 139.692626);
//    marker.title = @"Shibuya";
//    marker.snippet = @"Tokyo";
//    marker.map = _mapView;
    
    
    
    
    
    
    [self initLocationManager];
    
    [self start];
}


- (void)initLocationManager{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
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
    
    double latitude = currentLocation.coordinate.latitude + 0.00010696 * currentLocation.coordinate.latitude - 0.000017467 * currentLocation.coordinate.longitude - 0.0046020;
    double longitude = currentLocation.coordinate.longitude + 0.000046047 * currentLocation.coordinate.latitude + 0.000083049 * currentLocation.coordinate.longitude - 0.010041;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:12];
    [_mapView moveCamera:[GMSCameraUpdate setCamera:camera]];
    
    
    
}

@end

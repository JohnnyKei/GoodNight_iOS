//
//  GNDetailHotel.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNDetailHotel.h"

@interface GNDetailHotel ()

@property (nonatomic, strong, readwrite)NSString *area;
@property (nonatomic, strong, readwrite)NSString *address;
@property (nonatomic, strong, readwrite)NSString *checkIn;
@property (nonatomic, strong, readwrite)NSString *checkOut;
@property (nonatomic, strong, readwrite)NSString *hotelDescription;
@property (nonatomic, strong, readwrite)NSString *imageURL;
@property (nonatomic, strong, readwrite)NSString *tel;
@property (nonatomic, strong, readwrite)NSString *name;
@property (nonatomic, readwrite)BOOL haveInternet;
@property (nonatomic, readwrite)BOOL haveBar;
@property (nonatomic, readwrite)BOOL haveBeautySalon;
@property (nonatomic, readwrite)BOOL haveFitness;
@property (nonatomic, readwrite)BOOL haveParking;
@property (nonatomic, readwrite)BOOL havePet;
@property (nonatomic, readwrite)BOOL haveRoomService;
@property (nonatomic, readwrite)BOOL haveRestaurant;
@property (nonatomic, readwrite)CGFloat latitude;
@property (nonatomic, readwrite)CGFloat longitude;
@end

@implementation GNDetailHotel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.area = [dic[@"area"] objectForKey:@"name"];
        self.address = dic[@"address"];
        self.checkIn = dic[@"check_in"];
        self.checkOut = dic[@"check_out"];
        self.hotelDescription = dic[@"description"];
        self.imageURL = [[dic[@"image"] objectForKey:@"image"] objectForKey:@"url"];
        self.tel = dic[@"tel"];
        self.name = dic[@"name"];
        self.latitude = [dic[@"latitude"] floatValue];
        self.longitude = [dic[@"longitude"] floatValue];
        self.haveBar = [dic[@"bar"]boolValue];
        self.haveBeautySalon = [dic[@"beauty_salon"]boolValue];
        self.haveFitness = [dic[@"fitness"]boolValue];
        self.haveInternet = [dic[@"internet"]boolValue];
        self.haveParking = [dic[@"parking"]boolValue];
        self.havePet = [dic[@"pet"]boolValue];
        self.haveRoomService = [dic[@"roomservice"]boolValue];
        self.haveRestaurant = [dic[@"restaurant"]boolValue];
        
        DLog(@"%@",[self.checkOut class]);
        
    }
    return self;
}

@end

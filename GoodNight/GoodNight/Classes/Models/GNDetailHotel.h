//
//  GNDetailHotel.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNDetailHotel : NSObject


@property (nonatomic, strong, readonly)NSString *area;
@property (nonatomic, strong, readonly)NSString *address;
@property (nonatomic, strong, readonly)NSString *checkIn;
@property (nonatomic, strong, readonly)NSString *checkOut;
@property (nonatomic, strong, readonly)NSString *hotelDescription;
@property (nonatomic, strong, readonly)NSString *imageURL;
@property (nonatomic, strong, readonly)NSString *tel;
@property (nonatomic, strong, readonly)NSString *name;
@property (nonatomic, readonly)BOOL haveInternet;
@property (nonatomic, readonly)BOOL haveBar;
@property (nonatomic, readonly)BOOL haveBeautySalon;
@property (nonatomic, readonly)BOOL haveFitness;
@property (nonatomic, readonly)BOOL haveParking;
@property (nonatomic, readonly)BOOL havePet;
@property (nonatomic, readonly)BOOL haveRoomService;
@property (nonatomic, readonly)BOOL haveRestaurant;
@property (nonatomic, readonly)CGFloat latitude;
@property (nonatomic, readonly)CGFloat longitude;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

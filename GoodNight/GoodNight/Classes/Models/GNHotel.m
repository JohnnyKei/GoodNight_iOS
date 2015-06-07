//
//  GNHotel.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNHotel.h"

@interface GNHotel ()

@property (nonatomic, strong, readwrite)NSString *name;
@property (nonatomic, assign, readwrite)CGFloat latitude;
@property (nonatomic, assign, readwrite)CGFloat longitude;
@property (nonatomic, strong, readwrite)NSString *detailURL;
@property (nonatomic, strong, readwrite)NSString *areaName;
@property (nonatomic, strong, readwrite)NSString *thumbnail;

@end

@implementation GNHotel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.latitude = [dictionary[@"latitude"] floatValue];
        self.longitude = [dictionary[@"longitude"] floatValue];
        self.detailURL = dictionary[@"url"];
        self.areaName = [dictionary[@"area"] objectForKey:@"name"];
        self.thumbnail = [[[dictionary[@"image"] objectForKey:@"image"] objectForKey:@"medium"] objectForKey:@"url"];
    }
    return self;
}

@end

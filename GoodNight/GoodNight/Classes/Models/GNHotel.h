//
//  GNHotel.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNHotel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@property (nonatomic, strong, readonly)NSString *name;
@property (nonatomic, assign, readonly)CGFloat latitude;
@property (nonatomic, assign, readonly)CGFloat longitude;
@property (nonatomic, strong, readonly)NSString *address;
@property (nonatomic, strong, readonly)NSString *detailURL;

@end

//
//  GDApiMnager.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNApiMnager : NSObject

+ (instancetype)sharedManager;
- (void)getRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
- (void)postRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

- (void)getHTTPRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
@end


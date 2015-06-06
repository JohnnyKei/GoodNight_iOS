//
//  GDApiMnager.h
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDApiMnager : NSObject

+ (instancetype)sharedManager;
- (void)getRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
- (void)postRequest:(NSString *)urlString params:(NSDictionary *)params uccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
@end

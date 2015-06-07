//
//  GDApiMnager.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNApiMnager.h"
#import <AFNetworking/AFNetworking.h>

static GNApiMnager *_manager = nil;

@implementation GNApiMnager

+ (instancetype)sharedManager{
    @synchronized(self){
        if (!_manager) {
            _manager = [[GNApiMnager alloc]init];
        }
    }
    return _manager;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)getRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}


- (void)getHTTPRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [ud objectForKey:UBER_ACCESS_TOKEN];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];

    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

- (void)postRequest:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

@end

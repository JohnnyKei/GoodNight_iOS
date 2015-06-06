//
//  GDApiMnager.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GDApiMnager.h"
#import <AFNetworking/AFNetworking.h>

static GDApiMnager *_manager = nil;

@implementation GDApiMnager

+ (instancetype)sharedManager{
    @synchronized(self){
        if (!_manager) {
            _manager = [[GDApiMnager alloc]init];
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
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

- (void)postRequest:(NSString *)urlString params:(NSDictionary *)params uccess:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

@end

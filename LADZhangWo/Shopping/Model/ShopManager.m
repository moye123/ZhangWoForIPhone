//
//  ShopManager.m
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShopManager.h"

@implementation ShopManager

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedManager{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)requestWithAction:(NSString *)action parameters:(NSDictionary *)dict success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=shop&a=%@",action];
    [[AFHTTPSessionManager sharedManager] POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)add:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self requestWithAction:@"add" parameters:dict success:success failure:failure];
}

- (void)save:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self requestWithAction:@"save" parameters:dict success:success failure:failure];
}

- (void)delete:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self requestWithAction:@"delete" parameters:dict success:success failure:failure];
}

- (void)GET:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    CLLocationCoordinate2D coordinate = [[DSXCLLocationManager sharedManager] coordinate];
    NSMutableDictionary *parameters;
    if ([params isKindOfClass:[NSDictionary class]]) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    }else {
        parameters = [NSMutableDictionary dictionary];
    }
    [parameters setObject:@(coordinate.longitude) forKey:@"longitude"];
    [parameters setObject:@(coordinate.latitude) forKey:@"latitude"];
    
    [[AFHTTPSessionManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=shop"] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

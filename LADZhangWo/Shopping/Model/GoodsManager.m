//
//  GoodsManager.m
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GoodsManager.h"

@implementation GoodsManager

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


- (void)add:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[DSXHttpManager sharedManager] POST:@"&c=goods&a=add" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)save:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[DSXHttpManager sharedManager] POST:@"&c=goods&a=save" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)delete:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[DSXHttpManager sharedManager] POST:@"&c=goods&a=delete" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end

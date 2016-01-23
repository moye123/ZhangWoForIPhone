//
//  ShopManager.h
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopModel.h"

@interface ShopManager : NSObject

- (instancetype)init;
+ (instancetype)sharedManager;
- (void)add:(NSDictionary *)dict success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
- (void)save:(NSDictionary *)dict success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
- (void)delete:(NSDictionary *)dict success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
- (void)GET:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end

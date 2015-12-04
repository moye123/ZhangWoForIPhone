//
//  ZWUserStatus.h
//  songdewei
//
//  Created by Apple on 15/11/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWCommon.h"

UIKIT_EXTERN NSString *const UserStatusChangedNotification;
UIKIT_EXTERN NSString *const UserImageChangedNotification;

@interface ZWUserStatus : NSObject
- (instancetype)init;
+ (instancetype)sharedStatus;
- (void)reloadData;
- (void)logout;
- (void)update;
- (void)removeImageCache;

- (void)login:(NSMutableDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSString *errorMsg))failure;
- (void)register:(NSMutableDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSString *errorMsg))failure;

@property(nonatomic,readonly,assign)NSInteger uid;
@property(nonatomic,readonly,setter=setUsername:)NSString *username;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *userpic;
@property(nonatomic,strong)NSString *userip;
@property(nonatomic,readonly,strong)NSDictionary *userInfo;
@property(nonatomic,readonly,assign)BOOL isLogined;
@property(nonatomic,readonly,retain)UIImage *image;

@end
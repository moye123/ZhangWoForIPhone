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
+ (instancetype)status;
- (void)reloadData;
- (void)login:(NSMutableDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSString *errorMsg))failure;
- (void)register:(NSMutableDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSString *errorMsg))failure;
- (void)logout;
- (void)update;
- (void)removeImageCache;

@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *userpic;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,assign)BOOL isLogined;
@property(nonatomic,readonly,setter=setImageView:)UIImageView *imageView;

@end
//
//  ZWUserStatus.h
//  songdewei
//
//  Created by Apple on 15/11/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWCommon.h"
#import "LoginViewController.h"

UIKIT_EXTERN NSString *const UserStatusChangedNotification;
UIKIT_EXTERN NSString *const UserImageChangedNotification;

@interface ZWUserStatus : NSObject
- (instancetype)init;
+ (instancetype)sharedStatus;
- (void)reloadData;
- (void)logout;
- (void)update;
- (void)removeImageCache;

- (void)login:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSString *errorMsg))failure;
- (void)register:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSString *errorMsg))failure;
- (void)showLoginFromViewController:(UIViewController *)vc;

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
//
//  ZWUserStatus.m
//  LADLihuibao
//
//  Created by Apple on 15/11/5.
//  Copyright © 2015年 Apple. All rights reserved.
//
//

#import "ZWUserStatus.h"

NSString *const UserStatusChangedNotification = @"userStatusChanged";

@implementation ZWUserStatus
@synthesize uid;
@synthesize username;
@synthesize email;
@synthesize mobile;
@synthesize userpic;
@synthesize userInfo;
@synthesize isLogined;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self reloadData];
    }
    return self;
}

+ (instancetype)status{
    return [[self alloc] init];
}

- (void)reloadData{
    self.userInfo = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userinfo"];
    self.uid = [[self.userInfo objectForKey:@"uid"] integerValue];
    self.username = [self.userInfo objectForKey:@"username"];
    if (self.uid && self.username) {
        self.isLogined = YES;
        self.email = [self.userInfo objectForKey:@"email"];
        self.mobile = [self.userInfo objectForKey:@"mobile"];
        self.userpic = [self.userInfo objectForKey:@"userpic"];
    }else {
        self.isLogined = NO;
        self.email = nil;
        self.mobile = nil;
        self.userpic = nil;
        self.userInfo = [NSDictionary dictionary];
    }
}

- (void)login:(NSMutableDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[SITEAPI stringByAppendingString:@"&mod=member&ac=login"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            NSInteger myuid = [[dictionary objectForKey:@"uid"] integerValue];
            NSString *myusername = [dictionary objectForKey:@"username"];
            if (myuid > 0 && myusername) {
                [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"userinfo"];
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
                success(dictionary);
            }else {
                int errorCode = [[dictionary objectForKey:@"errorno"] intValue];
                NSString *errorMsg = nil;
                switch (errorCode) {
                    case -1 :
                        errorMsg = @"验证码错误";
                        break;
                    case -2 :
                        errorMsg = @"账号错误";
                        break;
                    case -3 :
                        errorMsg = @"密码错误";
                        break;
                    case -4 :
                        errorMsg = @"账号和密码不匹配";
                        break;
                        
                    default: errorMsg = @"内部错误";
                        break;
                }
                failure(errorMsg);
            }
        }else {
            failure(@"内部错误");
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)register:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[SITEAPI stringByAppendingString:@"&mod=member&ac=register"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([dictionary isKindOfClass:[NSDictionary class]]){
            
            NSInteger myuid = [[dictionary objectForKey:@"uid"] integerValue];
            NSString *myusername = [dictionary objectForKey:@"username"];
            if (myuid > 0 && myusername) {
                [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"userinfo"];
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
                success(dictionary);
            }else {
                int errorCode = [[dictionary objectForKey:@"errorno"] intValue];
                NSString *errorMsg = nil;
                switch (errorCode) {
                    case -1 :
                        errorMsg = @"邮箱格式错误";
                        break;
                    case -2 :
                        errorMsg = @"邮箱已被注册";
                        break;
                    case -3 :
                        errorMsg = @"手机号码格式错误";
                        break;
                    case -4 :
                        errorMsg = @"手机验证码错误";
                        break;
                    case -5 :
                        errorMsg = @"手机号码已被注册";
                        break;
                    case -6 :
                        errorMsg = @"密码长度错误，至少6位";
                        break;
                        
                    default: errorMsg = @"非法操作";
                        break;
                }
                
                failure(errorMsg);
            }
        }else{
            failure(@"内部错误");
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
}

@end
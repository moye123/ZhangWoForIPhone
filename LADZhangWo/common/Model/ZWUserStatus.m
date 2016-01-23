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
NSString *const UserImageChangedNotification = @"userImageChanged";

@implementation ZWUserStatus
@synthesize uid = _uid;
@synthesize username = _username;
@synthesize email    = _email;
@synthesize mobile   = _mobile;
@synthesize userpic  = _userpic;
@synthesize userip   = _userip;
@synthesize userInfo = _userInfo;
@synthesize isLogined = _isLogined;
@synthesize image = _image;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self reloadData];
    }
    return self;
}

+ (instancetype)sharedStatus{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)setUid:(NSInteger)uid{
    _uid = uid;
}

- (void)setUsername:(NSString *)username{
    _username = username;
}

- (void)setUserpic:(NSString *)userpic{
    _userpic = userpic;
    [self removeImageCache];
}

- (NSDictionary *)userInfo{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (_isLogined) {
        [userInfo setObject:@(_uid) forKey:@"uid"];
        [userInfo setObject:_username forKey:@"username"];
        [userInfo setObject:_email forKey:@"email"];
        [userInfo setObject:_mobile forKey:@"mobile"];
        [userInfo setObject:_userpic forKey:@"userpic"];
        [userInfo setObject:_userip forKey:@"userip"];
    }
    return userInfo;
}

- (UIImage *)image{
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"avatar"];
    if (cacheImage == nil) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_userpic] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:@"avatar" toDisk:YES];
        }];
    }
    return cacheImage;
}

- (void)removeImageCache{
    [[SDImageCache sharedImageCache] removeImageForKey:_userpic fromDisk:YES];
    [[SDImageCache sharedImageCache] removeImageForKey:@"avatar" fromDisk:YES];
}

- (void)reloadData{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userinfo"];
    [self setUid:[[dict objectForKey:@"uid"] integerValue]];
    [self setUsername:[dict objectForKey:@"username"]];
    if (_uid > 0 && [_username length] > 0) {
        _isLogined = YES;
        _email = [dict objectForKey:@"email"];
        _mobile = [dict objectForKey:@"mobile"];
        _userpic = [dict objectForKey:@"userpic"];
        _userip = [dict objectForKey:@"userip"];
    }else {
        _isLogined = NO;
        _email = @"";
        _mobile = @"";
        _userpic = @"";
        _userip = @"";
    }
    [self removeImageCache];
}

- (void)saveData:(NSDictionary *)userInfo{
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userinfo"];
}

- (void)update{
    [self removeImageCache];
    [self saveData:[self userInfo]];
}

- (void)login:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure{
    [[DSXHttpManager sharedManager] POST:@"&c=member&a=login" parameters:params progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSDictionary *info = [responseObject objectForKey:@"data"];
                [self saveData:info];
                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
                success(info);
            }else {
                NSString *errorMsg = [responseObject objectForKey:@"error"];
                failure(errorMsg);
            }
        }else {
            failure(@"内部错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)register:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    
    [[DSXHttpManager sharedManager] POST:@"&c=member&a=register" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if([[responseObject objectForKey:@"errno"] intValue] == 0){
                NSDictionary *info = [responseObject objectForKey:@"data"];
                [self saveData:info];
                [[ZWUserStatus sharedStatus] reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
                success(info);
            }else {
                NSString *errorMsg = [responseObject objectForKey:@"error"];
                failure(errorMsg);
            }
        }else {
            failure(@"内部错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
    [self removeImageCache];
    [[ZWUserStatus sharedStatus] reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
}

- (void)showLoginFromViewController:(UIViewController *)vc{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:loginView];
    [vc presentViewController:nav animated:YES completion:nil];
    
}

@end
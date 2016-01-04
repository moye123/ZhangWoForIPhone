//
//  DSXPayManager.h
//  LADZhangWo
//
//  Created by Apple on 15/12/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "ZWCommon.h"
@class DSXPayManager;
@protocol DSXPayManagerDelegate<NSObject>
@optional
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)payManager:(DSXPayManager *)manager didFinishedWithCode:(int)errCode;
@end

@interface DSXPayManager : NSObject<WXApiDelegate>
- (instancetype)init;
+ (instancetype)sharedManager;
@property(nonatomic)NSString *orderNO;
@property(nonatomic)NSString *orderName;
@property(nonatomic)NSString *orderDetail;
@property(nonatomic)NSString *orderAmount;
@property(nonatomic)NSString *payType;
@property(nonatomic)NSString *payID;
@property(nonatomic)NSString *payChannel;
@property(nonatomic,assign)id<DSXPayManagerDelegate>delegate;
- (void)WechatPay;
@end

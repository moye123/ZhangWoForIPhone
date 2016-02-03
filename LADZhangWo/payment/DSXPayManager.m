//
//  DSXPayManager.m
//  LADZhangWo
//
//  Created by Apple on 15/12/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DSXPayManager.h"

@implementation DSXPayManager
@synthesize orderNO     = _orderNO;
@synthesize orderName   = _orderName;
@synthesize orderDetail = _orderDetail;
@synthesize orderAmount = _orderAmount;
@synthesize payType     = _payType;
@synthesize payID       = _payID;
@synthesize delegate    = _delegate;

- (instancetype)init{
    if (self = [super init]) {
        if (!_payType) {
            _payType = @"recharge";
        }
        if (!_payID) {
            _payID = @"0";
        }
        _errCode = 0;
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

//微信支付
- (void)WechatPay {
    NSDictionary *params = @{@"orderno":_orderNO,
                             @"ordername":_orderName,
                             @"orderdetail":_orderDetail,
                             @"orderamount":_orderAmount,
                             @"paytype":_payType,
                             @"payid":_payID};

    UIView *loadingView = [[DSXUI standardUI] showLoadingViewWithMessage:@"交易处理中.."];
    [[DSXHttpManager sharedManager] POST:@"&c=weixin&a=sign" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [loadingView removeFromSuperview];
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSDictionary *returns = [responseObject objectForKey:@"data"];
                PayReq *request   = [[PayReq alloc] init];
                request.partnerId = [returns  objectForKey:@"partnerid"];
                request.prepayId  = [returns  objectForKey:@"prepayid"];
                request.nonceStr  = [returns  objectForKey:@"noncestr"];
                request.timeStamp = [[returns objectForKey:@"timestamp"] intValue];
                request.package   = [returns  objectForKey:@"package"];
                request.sign      = [returns  objectForKey:@"sign"];
                [WXApi sendReq:request];
            }
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"网络连接失败,请稍候再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [loadingView removeFromSuperview];
        NSLog(@"%@", error);
    }];
    
    /*
    NSData *response = [self postData:params toURL:urlString];
    id dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    //NSLog(@"%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        PayReq *request   = [[PayReq alloc] init];
        request.partnerId = [dict  objectForKey:@"partnerid"];
        request.prepayId  = [dict  objectForKey:@"prepayid"];
        request.nonceStr  = [dict  objectForKey:@"noncestr"];
        request.timeStamp = [[dict objectForKey:@"timestamp"] intValue];
        request.package   = [dict  objectForKey:@"package"];
        request.sign      = [dict  objectForKey:@"sign"];
        [WXApi sendReq:request];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"网络连接失败,请稍候再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
     */
}


- (NSString *)paramsToString:(NSDictionary *)params{
    NSArray *keys = [params allKeys];
    NSString *string = @"";
    NSString *comma  = @"";
    for (NSString *key in keys) {
        string = [string stringByAppendingFormat:@"%@%@=%@",comma,key,[params objectForKey:key]];
        comma = @"&";
    }
    return string;
}

- (NSData *)postData:(NSDictionary *)params toURL:(NSString *)urlString{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *body = [[self paramsToString:params] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功!";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeCommon:
                strMsg = @"未知错误";
                break;
            case WXErrCodeSentFail:
                strMsg = @"请求发送失败";
                break;
            case WXErrCodeUnsupport:
                strMsg = @"你的设备暂不支持微信支付";
                break;
            case WXErrCodeUserCancel:
                strMsg = @"交易已取消";
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        _errCode = resp.errCode;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert setTag:101];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (_delegate && [_delegate respondsToSelector:@selector(payManager:didFinishedWithCode:)]) {
            [_delegate payManager:self didFinishedWithCode:_errCode];
        }
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end

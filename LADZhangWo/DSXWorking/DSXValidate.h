//
//  DSXValidate.h
//  LADZhangWo
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXValidate : NSObject

//用户名验证
+ (BOOL) validateUserName:(NSString *)name;
//密码验证
+ (BOOL) validatePassword:(NSString *)passWord;
//昵称验证
+ (BOOL) validateNickname:(NSString *)nickname;
//邮箱验证
+ (BOOL) validateEmail:(NSString *)email;
//手机验证
+ (BOOL) validateMobile:(NSString *)mobile;
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
//车型验证
+ (BOOL) validateCarType:(NSString *)CarType;
//身份证号验证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

@end

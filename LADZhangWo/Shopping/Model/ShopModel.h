//
//  ShopModel.h
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWCommon.h"

@interface ShopModel : NSObject

@property(nonatomic)NSString *shopid;
@property(nonatomic)NSString *catid;
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *username;
@property(nonatomic)NSString *shopname;
@property(nonatomic)NSString *pic;
@property(nonatomic)NSString *desc;
@property(nonatomic)NSString *province;
@property(nonatomic)NSString *city;
@property(nonatomic)NSString *address;
@property(nonatomic)NSString *tel;
@property(nonatomic)NSString *verify;
@property(nonatomic)NSString *dateline;
@property(nonatomic)NSString *distance;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)model;
- (NSDictionary *)getData;

@end

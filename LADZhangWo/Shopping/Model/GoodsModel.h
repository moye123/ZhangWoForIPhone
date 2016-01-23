//
//  GoodsModel.h
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWCommon.h"

@interface GoodsModel : NSObject

@property(nonatomic)NSString *goodsid;
@property(nonatomic)NSString *catid;
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *username;
@property(nonatomic)NSString *shopid;
@property(nonatomic)NSString *shopname;
@property(nonatomic)NSString *name;
@property(nonatomic)NSString *sn;
@property(nonatomic)NSString *price;
@property(nonatomic)NSString *stock;
@property(nonatomic)NSString *sold;
@property(nonatomic)NSString *pic;
@property(nonatomic)NSString *score;
@property(nonatomic)NSString *dateline;
@property(nonatomic)NSString *viewnum;
@property(nonatomic)NSString *commentnum;
@property(nonatomic)NSString *distance;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)model;
- (NSDictionary *)getData;

@end

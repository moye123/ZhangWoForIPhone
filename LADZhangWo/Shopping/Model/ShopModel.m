//
//  ShopModel.m
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.shopid      = [dict objectForKey:@"shopid"];
        self.catid       = [dict objectForKey:@"catid"];
        self.uid         = [dict objectForKey:@"uid"];
        self.username    = [dict objectForKey:@"username"];
        self.shopname    = [dict objectForKey:@"shopname"];
        self.pic         = [dict objectForKey:@"pic"];
        self.desc        = [dict objectForKey:@"description"];
        self.province    = [dict objectForKey:@"province"];
        self.city        = [dict objectForKey:@"city"];
        self.address     = [dict objectForKey:@"address"];
        self.tel         = [dict objectForKey:@"tel"];
        self.verify      = [dict objectForKey:@"verify"];
        self.dateline    = [dict objectForKey:@"dateline"];
        self.distance    = [dict objectForKey:@"distance"];
    }
    return self;
}

+ (instancetype)model{
    return [[self alloc] init];
}

- (NSDictionary *)getData{
    NSDictionary *dict = [[NSDictionary alloc] init];
    return dict;
}

@end
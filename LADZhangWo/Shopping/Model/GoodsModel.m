//
//  GoodsModel.m
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.goodsid    = [dict objectForKey:@"id"];
        self.catid      = [dict objectForKey:@"catid"];
        self.uid        = [dict objectForKey:@"uid"];
        self.username   = [dict objectForKey:@"username"];
        self.shopid     = [dict objectForKey:@"shopid"];
        self.shopname   = [dict objectForKey:@"shopname"];
        self.name       = [dict objectForKey:@"name"];
        self.sn         = [dict objectForKey:@"sn"];
        self.price      = [dict objectForKey:@"price"];
        self.stock      = [dict objectForKey:@"stock"];
        self.sold       = [dict objectForKey:@"sold"];
        self.pic        = [dict objectForKey:@"pic"];
        self.score      = [dict objectForKey:@"score"];
        self.dateline   = [dict objectForKey:@"dateline"];
        self.viewnum    = [dict objectForKey:@"viewnum"];
        self.commentnum = [dict objectForKey:@"commentnum"];
        self.distance   = [dict objectForKey:@"distance"];
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

//
//  CartInfoModel.m
//  LADZhangWo
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CartInfoModel.h"

@implementation CartInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.cartID = [[dict objectForKey:@"cartid"] integerValue];
        self.goodsID = [[dict objectForKey:@"goodsID"] integerValue];
        self.goodsName = [dict objectForKey:@"goodsName"];
        self.goodsImage = [dict objectForKey:@"goodsImage"];
        self.goodsPrice = [[dict objectForKey:@"goodsPrice"] floatValue];
        self.goodsNum = [[dict objectForKey:@"goodsNum"] integerValue];
        self.selectState = [[dict objectForKey:@"selectSate"] boolValue];
        self.shopName = [dict objectForKey:@"shopName"];
    }
    return self;
}

@end

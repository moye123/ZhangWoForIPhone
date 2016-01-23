//
//  FavoriteModel.m
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FavoriteModel.h"

@implementation FavoriteModel
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.favid    = [dict objectForKey:@"favid"];
        self.uid      = [dict objectForKey:@"uid"];
        self.dataid   = [dict objectForKey:@"dataid"];
        self.datatype = [dict objectForKey:@"datatype"];
        self.pic      = [dict objectForKey:@"pic"];
        self.title    = [dict objectForKey:@"title"];
        self.dateline = [dict objectForKey:@"dateline"];
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

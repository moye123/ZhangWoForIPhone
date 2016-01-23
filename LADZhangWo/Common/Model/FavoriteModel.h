//
//  FavoriteModel.h
//  XiangBaLao
//
//  Created by Apple on 16/1/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject

@property(nonatomic)NSString *favid;
@property(nonatomic)NSString *uid;
@property(nonatomic)NSString *dataid;
@property(nonatomic)NSString *datatype;
@property(nonatomic)NSString *pic;
@property(nonatomic)NSString *title;
@property(nonatomic)NSString *dateline;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)model;

@end

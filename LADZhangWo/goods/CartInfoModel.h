//
//  CartInfoModel.h
//  LADZhangWo
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartInfoModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;

@property(nonatomic)NSInteger cartID;
@property(nonatomic)NSInteger goodsID;
@property(nonatomic)NSString *goodsName;
@property(nonatomic)NSString *goodsImage;
@property(nonatomic)float goodsPrice;
@property(nonatomic)NSInteger goodsNum;
@property(nonatomic)NSString *shopName;
@property(nonatomic)NSString *goodsFrom;
@property(nonatomic)BOOL selectState;

@end

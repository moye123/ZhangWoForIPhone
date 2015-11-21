//
//  DSXUtil.h
//  YuShuiHePan
//
//  Created by songdewei on 15/10/5.
//  Copyright © 2015年 yushuihepan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSXUI.h"
#import "LHBConfig.h"

@interface DSXUtil : NSObject

+ (instancetype)sharedUtil;

- (void)nslogStringWithData:(NSData *)data;
- (NSData *)dataWithURL:(NSString *)urlString;
- (NSData *)sendDataForURL:(NSString *)urlString params:(NSMutableDictionary *)params;
- (void)addFavoriteWithParams:(NSMutableDictionary *)params;
- (NSDictionary *)parseQueryString:(NSString *)query;

@end

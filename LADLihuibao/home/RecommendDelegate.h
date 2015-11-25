//
//  RecommendDelegate.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

@protocol RecommendDelegate <NSObject>
@optional
- (void)showDetailWithID:(NSInteger)ID andIdType:(NSString *)idtype;

@end

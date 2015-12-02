//
//  RecommendSliderView2.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
#import "RecommendDelegate.h"
@interface RecommendSliderView2 : UIScrollView{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    NSMutableDictionary *_idTypes;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loadData;

@property(nonatomic,assign)NSInteger groupid;
@property(nonatomic,assign)NSInteger dataCount;
@property(nonatomic,assign)id<RecommendDelegate>tapDelegate;

@end

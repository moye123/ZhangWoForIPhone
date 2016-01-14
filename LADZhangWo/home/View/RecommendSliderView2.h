//
//  RecommendSliderView2.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "RecommendDelegate.h"
@interface RecommendSliderView2 : UIScrollView{
    @private
    NSMutableDictionary *_idTypes;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loadData;

@property(nonatomic,assign)int groupid;
@property(nonatomic,assign)int dataCount;
@property(nonatomic,assign)id<RecommendDelegate>tapDelegate;

@end

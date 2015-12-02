//
//  RecommendSliderView.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "RecommendDelegate.h"

@interface RecommendSliderView : UIScrollView{
    @private
    NSMutableDictionary *_idTypes;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loadData;
@property(nonatomic,assign)id<RecommendDelegate>tapDelegate;
@property(nonatomic,assign)NSInteger groupid;
@property(nonatomic,assign)NSInteger dataCount;
@property(nonatomic,assign)CGFloat imgWidth;
@property(nonatomic,assign)CGFloat imgHeight;

@end

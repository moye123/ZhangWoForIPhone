//
//  HomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "ChannelListView.h"
#import "RecommendSliderView.h"
#import "RecommendSliderView2.h"
#import "localView.h"
#import "searchBar.h"
#import "DistrictViewController.h"
#import "HomeTitleCell.h"
#import "HomeGoodsCell.h"

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RecommendDelegate,LocationChangeDelegate,DSXSliderViewDelegate,ChannelViewDelegate,UITextFieldDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
    DSXSliderView *_slideView;
    DSXSliderView *_shopSlideView;
    NSArray *_goodsList;
}

- (instancetype)init;

@property(nonatomic,retain)localView *local;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ChannelListView *channelView;
@property(nonatomic,retain)RecommendSliderView *travelView;
@property(nonatomic,retain)RecommendSliderView *productView;
@property(nonatomic,retain)RecommendSliderView2 *foodView;

@end

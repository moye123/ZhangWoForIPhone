//
//  HomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "HomeCategoryView.h"
#import "RecommendSliderView.h"
#import "RecommendSliderView2.h"
#import "localView.h"
#import "searchBar.h"
#import "DistrictViewController.h"
@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,showCategoryDelegate,RecommendDelegate,LocationChangeDelegate>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    DSXPopMenu *_popMenu;
}

- (instancetype)init;

@property(nonatomic,retain)localView *local;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)HomeCategoryView *categoryView;
@property(nonatomic,retain)RecommendSliderView *businessView;
@property(nonatomic,retain)RecommendSliderView *travelView;
@property(nonatomic,retain)RecommendSliderView *productView;
@property(nonatomic,retain)RecommendSliderView2 *foodView;

@end

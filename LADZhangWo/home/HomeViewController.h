//
//  HomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "localView.h"
#import "HomeSearchView.h"
#import "CategoryView.h"
#import "TitleCell.h"
#import "GoodsItemCell.h"
#import "TravelSliderView.h"
#import "GalleryView.h"
#import "SliderView.h"
#import "DistrictViewController.h"
#import "ShowAdModel.h"

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LocationChangeDelegate,DSXSliderViewDelegate,CategoryViewDelegate,TravelSliderViewDelegate,SliderViewDelegate,GalleryViewDelegate,UITextFieldDelegate>{
    @private
    localView *_localView;
    HomeSearchView *_searchView;
    DSXDropDownMenu *_popMenu;
    DSXSliderView *_slideView;
    DSXSliderView *_shopSlideView;
    NSArray *_goodsList;
    
    CategoryView *_channelView;
    TravelSliderView *_travelSliderView;
    SliderView *_specialGoodsView;
    GalleryView *_foodGalleryView;
}

@property(nonatomic,retain)UITableView *tableView;
@end

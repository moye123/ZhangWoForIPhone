//
//  CommunityViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"
#import "ShopItemCell.h"
#import "ShowAdModel.h"

@interface CommunityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DSXSliderViewDelegate,CategoryViewDelegate>{
    DSXSliderView *_sliderView;
    CategoryView *_categoryView;
    NSMutableArray *_shopList;
}

@property(nonatomic)UITableView *tableView;
@end

//
//  ServiceViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"
#import "ShopItemCell.h"
#import "HomeTitleCell.h"

@interface ServiceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DSXSliderViewDelegate,CategoryViewDelegate,DSXDropDownMenuDelegate>{
    @private
    DSXSliderView *_slideView;
    CategoryView *_categoryView;
    NSArray *_shopList;
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,strong)NSMutableArray *serviceList;
@property(nonatomic,retain)UITableView *tableView;

@end

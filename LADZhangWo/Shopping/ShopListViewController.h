//
//  ShopListViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopItemCell.h"

@interface ShopListViewController : UITableViewController<UIScrollViewDelegate,DSXDropDownMenuDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic)NSMutableArray *shopList;

@end

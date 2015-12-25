//
//  MyFavoriteViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavorItemCell.h"

@interface MyFavoriteViewController : UITableViewController<UIScrollViewDelegate>{
    ZWPullUpView*_pullUpView;
    ZWRefreshControl *_refreshContorl;
    AFHTTPRequestOperationManager *_afmanager;
    BOOL _isRefreshing;
    int _page;
}

@property(nonatomic,strong)NSMutableArray *favoriteList;
@end

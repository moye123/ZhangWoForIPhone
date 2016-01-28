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
    DSXPullUpView*_pullUpView;
    DSXRefreshControl *_refreshContorl;
    BOOL _isRefreshing;
    int _page;
    UIToolbar *_toolbar;
}

@property(nonatomic,strong)NSMutableArray *favoriteList;
@end

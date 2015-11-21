//
//  MyFavoriteViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface MyFavoriteViewController : UITableViewController<UIScrollViewDelegate>{
    LHBPullUpView *_pullUpView;
    LHBRefreshControl *_refreshContorl;
    BOOL _isRefreshing;
    int _page;
}

@property(nonatomic,strong)NSMutableArray *favoriteList;
@property(nonatomic,retain)LHBUserStatus *userStatus;
@property(nonatomic,retain)AFHTTPRequestOperationManager *afmanager;
@end

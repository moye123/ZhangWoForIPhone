//
//  MyOrderViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface MyOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    LHBRefreshControl *_refreshControl;
    LHBPullUpView *_pullUpView;
    BOOL _isRefreshing;
    int _page;
}

- (instancetype)init;

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSMutableArray *orderList;
@property(nonatomic,retain)LHBUserStatus *userStatus;
@property(nonatomic,retain)UITableView *tableView;

@end

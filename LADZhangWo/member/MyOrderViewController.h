//
//  MyOrderViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
    BOOL _isRefreshing;
    int _page;
}

- (instancetype)init;

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger evaluate;
@property(nonatomic,strong)NSMutableArray *orderList;
@property(nonatomic,retain)ZWUserStatus *userStatus;
@property(nonatomic,retain)UITableView *tableView;

@end

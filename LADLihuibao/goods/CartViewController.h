//
//  CartViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    int _page;
    BOOL _isRefreshing;
    LHBPullUpView *_pullUpView;
}

@property(nonatomic,strong)NSMutableArray *cartList;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)LHBUserStatus *userStatus;

@end

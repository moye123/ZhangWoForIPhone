//
//  MyBillViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyBillViewController : UITableViewController{
    @private
    AFHTTPRequestOperationManager *_afmanager;
    int _page;
    BOOL _isRefreshing;
    UILabel *_tipsView;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
}

@property(nonatomic,strong)NSMutableArray *billList;

@end

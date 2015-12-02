//
//  ChaoshiListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
#import "DSXStarView.h"

@interface ChaoshiListViewController : UITableViewController<UIScrollViewDelegate>{
@private
    int _page;
    BOOL _isRefreshing;
    LHBRefreshControl *_refreshControl;
    LHBPullUpView *_pullUpView;
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,assign)NSInteger catid;
@property(nonatomic,strong)NSMutableArray *goodsArray;

@end

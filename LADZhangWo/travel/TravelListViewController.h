//
//  TravelListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface TravelListViewController : UITableViewController<UIScrollViewDelegate>{
@private
    int _page;
    BOOL _isRefreshing;
    LHBRefreshControl *_refreshControl;
    LHBPullUpView *_pullUpView;
    UILabel *_tipsLabel;
    AFHTTPRequestOperationManager *_afmanager;
}
@property(nonatomic,strong)NSMutableArray *travelArray;
@property(nonatomic,assign)NSInteger catid;

@end

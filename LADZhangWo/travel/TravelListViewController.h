//
//  TravelListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface TravelListViewController : UITableViewController<UIScrollViewDelegate>{
@private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView*_pullUpView;
    UILabel *_tipsLabel;
    AFHTTPRequestOperationManager *_afmanager;
}
@property(nonatomic,strong)NSMutableArray *travelArray;
@property(nonatomic,assign)NSInteger catid;

@end

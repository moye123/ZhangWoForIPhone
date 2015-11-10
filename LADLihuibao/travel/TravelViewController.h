//
//  TravelViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface TravelViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    LHBRefreshControl *_refreshControl;
    LHBPullUpView *_pullUpView;
}

@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *travelArray;

@end

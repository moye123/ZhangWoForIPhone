//
//  DSXTableViewController.h
//  XiangBaLao
//
//  Created by Apple on 16/1/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXRefreshControl.h"
#import "UIScrollView+Refresh.h"

@interface DSXTableViewController : UIViewController<DSXRefreshDelegate>

@property(nonatomic,readonly)UITableView *tableView;
@property(nonatomic,readonly)DSXRefreshControl *refreshControl;
@property(nonatomic,readonly)NSMutableArray *dataList;
@property(nonatomic,strong)NSArray *moreData;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)BOOL isRefreshing;
@property(nonatomic,assign)BOOL refreshEnabled;

- (instancetype)init;
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (void)endLoad;

@end

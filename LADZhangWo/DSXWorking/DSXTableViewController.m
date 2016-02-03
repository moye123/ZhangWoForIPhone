//
//  DSXTableViewController.m
//  XiangBaLao
//
//  Created by Apple on 16/1/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXTableViewController.h"

@implementation DSXTableViewController
@synthesize tableView = _tableView;
@synthesize dataList  = _dataList;
@synthesize refreshControl = _refreshControl;
@synthesize refreshEnabled = _refreshEnabled;

- (instancetype)init{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super init]) {
        self.pageSize = 20;
        self.currentPage  = 1;
        self.isRefreshing = NO;
        _dataList       = [[NSMutableArray alloc] init];
        _tableView      = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        _refreshControl = [[DSXRefreshControl alloc] init];
    }
    return self;
}

- (void)setRefreshEnabled:(BOOL)refreshEnabled{
    _refreshEnabled = refreshEnabled;
    if (refreshEnabled == YES) {
        self.tableView.dsx_refreshControl = self.refreshControl;
    }else {
        self.tableView.dsx_refreshControl = nil;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.refreshControl.bottomHidden = YES;
    self.refreshControl.delegate = self;
    self.refreshEnabled = YES;
}

- (void)endLoad{
    self.refreshControl.bottomHidden = ([self.dataList count] < self.pageSize);
    if ([self.moreData count] < self.pageSize) {
        self.refreshControl.loadingState = DSXLoadingStateNoMoreData;
    }
}

#pragma mark - refresh delegate
- (void)willStartRefreshing:(DSXRefreshView *)refreshView{}
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{}
- (void)didEndRefreshing:(DSXRefreshView *)refreshView{}
- (void)willStartLoading:(DSXRefreshView *)refreshView{}
- (void)didStartLoading:(DSXRefreshView *)refreshView{}
- (void)didEndLoading:(DSXRefreshView *)refreshView{}

@end

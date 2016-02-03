//
//  NewsListView.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsListView.h"

@implementation NewsListView
@synthesize catid = _catid;
@synthesize sliderView = _sliderView;
@synthesize showDetailDelegate = _showDetailDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[NewsItemCell class] forCellReuseIdentifier:@"newsCell"];
        
        _sliderView = [[NewsSliderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width/2)];
        _sliderView.pageControl.hidden = YES;
        self.tableHeaderView = _sliderView;
        self.tableFooterView = [[UIView alloc] init];
        
        _newsList = [[NSMutableArray alloc] init];
        _refreshControl = [[DSXRefreshControl alloc] init];
        self.dsx_refreshControl = _refreshControl;
        self.dsx_refreshControl.delegate = self;
    }
    return self;
}

- (void)setShowDetailDelegate:(id<NewsSliderViewDelegate,NewsListDelegate>)showDetailDelegate{
    _showDetailDelegate = showDetailDelegate;
    _sliderView.delegate = showDetailDelegate;
}

- (void)show{
    NSString *key = [NSString stringWithFormat:@"newsList_%d", _catid];
    [self showTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
    [self didStartRefreshing:nil];
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    _page = 1;
    _isRefreshing = YES;
    [self loadDataSource];
}

- (void)didEndRefreshing:(DSXRefreshView *)refreshView{
    self.refreshControl.bottomHidden = ([_newsList count] < 20);
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    _page++;
    _isRefreshing = NO;
    [self loadDataSource];
}

- (void)didEndLoading:(DSXRefreshView *)refreshView{
    if ([_moreData count] < 20) {
        self.refreshControl.loadingState = DSXLoadingStateNoMoreData;
    }
}

#pragma mark - load dataSource

- (void)loadDataSource{
    NSDictionary *params = @{@"catid":@(_catid),@"page":@(_page)};
    if (_isRefreshing) {
        [[DSXHttpManager sharedManager] GET:@"&c=post&a=showlist&pagesize=3&pic=1" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                    _sliderView.dataList = [responseObject objectForKey:@"data"];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
    
    [[DSXHttpManager sharedManager] GET:@"&c=post&a=showlist&limit=3&pic=1" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _moreData = [responseObject objectForKey:@"data"];
                if (_isRefreshing && [_moreData count] > 0) {
                    NSString *key = [NSString stringWithFormat:@"newsList_%d",_catid];
                    [[NSUserDefaults standardUserDefaults] setObject:_moreData forKey:key];
                }
                [self showTableViewWithArray:_moreData];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [_newsList removeAllObjects];
            [self reloadData];
        }
        for (NSDictionary *dict in array) {
            [_newsList addObject:dict];
        }
        [self reloadData];
    }
    if ([_newsList count] < 20) {
        self.dsx_footerView.hidden = YES;
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_newsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    cell.newsData = [_newsList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *newsData = [_newsList objectAtIndex:indexPath.row];
    if ([_showDetailDelegate respondsToSelector:@selector(listView:didSelectedItemAtIndexPath:data:)]) {
        [_showDetailDelegate listView:self didSelectedItemAtIndexPath:indexPath data:newsData];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end

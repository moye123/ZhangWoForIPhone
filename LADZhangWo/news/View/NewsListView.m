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
        
        _refreshControl = [[DSXRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self;
        tableViewController.refreshControl = _refreshControl;
        [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        
        _pullUpView = [[DSXPullUpView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _pullUpView.hidden = YES;
        self.tableFooterView = _pullUpView;
        
        _sliderView = [[NewsSliderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width/2)];
        self.tableHeaderView = _sliderView;
        
        _newsList = [[NSMutableArray alloc] init];
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
    [self refresh];
}

- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self downloadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self downloadData];
}

- (void)downloadData{
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
                NSArray *array = [responseObject objectForKey:@"data"];
                if (_isRefreshing && [array count]>0) {
                    NSString *key = [NSString stringWithFormat:@"newsList_%d",_catid];
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:key];
                }
                [self showTableViewWithArray:array];
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
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else {
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
    
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    
}

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

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat diffHeight = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (diffHeight > 50) {
        if (_pullUpView.hidden == NO) {
            [_pullUpView beginLoading];
            [self loadMore];
        }
        
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

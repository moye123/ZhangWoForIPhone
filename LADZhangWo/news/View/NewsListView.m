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
@synthesize newsArray = _newsArray;
@synthesize showNewsDelegate = _showNewsDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self registerClass:[NewsItemCell class] forCellReuseIdentifier:@"newsCell"];
        
        _refreshControl = [[ZWRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self;
        tableViewController.refreshControl = _refreshControl;
        [_refreshControl addTarget:self action:@selector(reFreshTableView) forControlEvents:UIControlEventValueChanged];
        
        _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _pullUpView.hidden = YES;
        self.tableFooterView = _pullUpView;
        self.delegate = self;
        self.dataSource = self;
        self.newsArray = [NSMutableArray array];
    }
    return self;
}

- (void)showTableView{
    NSString *key = [NSString stringWithFormat:@"newsList_%d", _catid];
    [self showTableViewWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
    [self reFreshTableView];
}

- (void)loadData{
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=post&a=showlist&catid=%d&page=%d",_catid,_page];
    [[AFHTTPSessionManager sharedManager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (_isRefreshing && [responseObject count]>0) {
                NSString *key = [NSString stringWithFormat:@"newsList_%d",_catid];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:key];
            }
            [self showTableViewWithArray:responseObject];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}

- (void)showTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [self.newsArray removeAllObjects];
            [self reloadData];
        }
        for (NSDictionary *newsItem in array) {
            [self.newsArray addObject:newsItem];
        }
        [self reloadData];
    }
    if ([array count] >= 20) {
        _pullUpView.hidden = NO;
    }else {
        _pullUpView.hidden = YES;
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    [_pullUpView endLoading];
}

- (void)reFreshTableView{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 265;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    cell.newsData = [self.newsArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSInteger newsID = [[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    if ([self.showNewsDelegate respondsToSelector:@selector(showNewsDetailWithID:)]) {
        [self.showNewsDelegate showNewsDetailWithID:newsID];
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
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins  = UIEdgeInsetsZero;
}

@end

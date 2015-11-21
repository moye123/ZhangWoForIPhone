//
//  MyFavoriteViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyFavoriteViewController.h"

@implementation MyFavoriteViewController
@synthesize favoriteList = _favoriteList;
@synthesize userStatus;
@synthesize afmanager = _afmanager;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收藏"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _favoriteList = [NSMutableArray array];
    self.userStatus = [LHBUserStatus status];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _refreshContorl = [[LHBRefreshControl alloc] init];
    [_refreshContorl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    _pullUpView = [[LHBPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.refreshControl = _refreshContorl;
    self.tableView.tableFooterView = _pullUpView;
    
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh{
    _page = 1;
    _isRefreshing = YES;
    [self loadData];
}

- (void)loadMore{
    _page++;
    _isRefreshing = NO;
    [self loadData];
}

- (void)loadData{
    [_afmanager GET:[SITEAPI stringByAppendingFormat:@"&mod=member&ac=showfavorite&page=%d&uid=%ld",_page,(long)self.userStatus.uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:array];
        }else {
            [_pullUpView endLoading];
            [_refreshContorl endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            [_favoriteList removeAllObjects];
            [self.tableView reloadData];
        }
        for (NSDictionary *dict in array) {
            [_favoriteList addObject:dict];
        }
        [self.tableView reloadData];
    }
    
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else {
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
    
    if ([_refreshContorl isRefreshing]) {
        [_refreshContorl endRefreshing];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_favoriteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favorCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat diffHeight = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
    if (diffHeight > 50) {
        if (_pullUpView.hidden == NO) {
            [_pullUpView beginLoading];
            [self loadMore];
        }
        
    }
}

@end

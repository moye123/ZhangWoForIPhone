//
//  MyBillViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyBillViewController.h"

@implementation MyBillViewController
@synthesize billList = _billList;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的账单"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _billList = [NSMutableArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _refreshControl = [[ZWRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:_refreshControl];
    
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.tableView.tableFooterView = _pullUpView;
    
    _tipsView = [[DSXUI sharedUI] tipsViewWithTitle:@"账单空空也"];
    _tipsView.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:_tipsView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh{
    _page = 1;
    [self downloadData];
}

- (void)loadMore{
    _page++;
    [self downloadData];
}

- (void)downloadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [_afmanager POST:[SITEAPI stringByAppendingString:@"&mod=wallet&ac=showbill"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:array];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            _isRefreshing = NO;
            [_billList removeAllObjects];
            [self.tableView reloadData];
        }
        for (NSDictionary *dict in array) {
            [_billList addObject:dict];
        }
        [self.tableView reloadData];
    }
    if ([_billList count] == 0) {
        _tipsView.hidden = NO;
    }else {
        _tipsView.hidden = YES;
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    if ([array count] < 20) {
        _pullUpView.hidden = YES;
    }else {
        _pullUpView.hidden = NO;
    }
    [_pullUpView endLoading];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_billList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
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

    if (scrollView.contentOffset.y < -120) {
        [self refresh];
    }
}

@end

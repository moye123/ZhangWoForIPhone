//
//  MyIncomeViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyIncomeViewController.h"

@implementation MyIncomeViewController
@synthesize incomeList = _incomeList;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收益"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    _incomeList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor backColor];
    [self downloadData];
    
    DSXRefreshControl *refreshControl = [[DSXRefreshControl alloc] initWithScrollView:self.tableView];
    refreshControl.delegate = self;

    _tipsView = [[UILabel alloc] init];
    _tipsView.text = @"你还没有获得过任何收益";
    _tipsView.textColor = [UIColor grayColor];
    _tipsView.font = [UIFont systemFontOfSize:14.0];
    _tipsView.hidden = YES;
    [_tipsView sizeToFit];
    [_tipsView setCenter:CGPointMake(self.view.center.x, 200)];
    [self.view addSubview:_tipsView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
//从服务器下载数据
- (void)downloadData{
    _tipsView.hidden = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [[DSXHttpManager sharedManager] POST:@"&c=income&a=showinfo" parameters:@{@"page":@(_page)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:[responseObject objectForKey:@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
//刷新tableView
- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            _isRefreshing = NO;
            [_incomeList removeAllObjects];
            [self.tableView reloadData];
        }
        for (NSDictionary *dict in array) {
            [_incomeList addObject:dict];
        }
        [self.tableView reloadData];
    }
    if ([_incomeList count] == 0) {
        _tipsView.hidden = NO;
    }else {
        _tipsView.hidden = YES;
    }
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [self refresh];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [self loadMore];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_incomeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"incomeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"incomeCell"];
    }
    NSDictionary *info = [_incomeList objectAtIndex:indexPath.row];
    cell.textLabel.text = [info objectForKey:@"message"];
    cell.detailTextLabel.text = [info objectForKey:@"dateline"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

@end

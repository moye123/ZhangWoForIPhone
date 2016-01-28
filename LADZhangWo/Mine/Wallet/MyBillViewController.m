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
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    _billList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BillItemCell class] forCellReuseIdentifier:@"billCell"];
    
    DSXRefreshControl *refreshControl = [[DSXRefreshControl alloc] initWithScrollView:self.tableView];
    refreshControl.delegate = self;
    
    _tipsView = [DSXUI tipsViewWithTitle:@"账单空空也"];
    _tipsView.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:_tipsView];
    [self refresh];
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
    [self downloadData];
}

- (void)downloadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [params setObject:@(_page) forKey:@"page"];
    [[DSXHttpManager sharedManager] POST:@"&c=bill&a=showlist"
                              parameters:params
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self reloadTableViewWithArray:[responseObject objectForKey:@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    return [_billList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCell"];
    NSDictionary *billData = [_billList objectAtIndex:indexPath.row];
    [cell setBillData:billData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

@end

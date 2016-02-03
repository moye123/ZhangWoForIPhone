//
//  MyBillViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyBillViewController.h"

@implementation MyBillViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的账单"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BillItemCell class] forCellReuseIdentifier:@"billCell"];
    
    _tipsView = [DSXUI tipsViewWithTitle:@"账单空空也"];
    _tipsView.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:_tipsView];
    [self didStartRefreshing:nil];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [super didStartRefreshing:refreshView];
    self.currentPage = 1;
    self.isRefreshing = YES;
    [self loadDataSource];
}

- (void)didEndRefreshing:(DSXRefreshView *)refreshView{
    [super didEndRefreshing:refreshView];
    if ([self.dataList count] == 0) {
        _tipsView.hidden = NO;
    }else {
        _tipsView.hidden = YES;
    }
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [super didEndLoading:refreshView];
    self.currentPage++;
    self.isRefreshing = NO;
    [self loadDataSource];
}

#pragma mark - loadDataSource
- (void)loadDataSource{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
    [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
    [params setObject:@(self.currentPage) forKey:@"page"];
    [[DSXHttpManager sharedManager] GET:@"&c=bill&a=showlist" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                self.moreData = [responseObject objectForKey:@"data"];
                if ([self.moreData count] > 0) {
                    if (self.isRefreshing) {
                        self.isRefreshing = NO;
                        [self.dataList removeAllObjects];
                        [self.tableView reloadData];
                    }
                    for (NSDictionary *dict in self.moreData) {
                        [self.dataList addObject:dict];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BillItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCell"];
    NSDictionary *billData = [self.dataList objectAtIndex:indexPath.row];
    [cell setBillData:billData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

@end

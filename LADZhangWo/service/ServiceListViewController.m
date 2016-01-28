//
//  ServiceListViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceDetailViewController.h"

@implementation ServiceListViewController
@synthesize catid = _catid;
@synthesize serviceList = _serviceList;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    _serviceList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[ServiceItemCell class] forCellReuseIdentifier:@"serviceCell"];
    
    DSXRefreshControl *refreshControl = [[DSXRefreshControl alloc] initWithScrollView:self.tableView];
    refreshControl.delegate = self;
    
    _noaccessView.hidden = YES;
    _noaccessView.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:_noaccessView];
    
    [self refresh];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - download data
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
    [[DSXHttpManager sharedManager] GET:@"&c=service&a=showlist" parameters:@{@"catid":@(_catid),@"page":@(_page)}
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        [self reloadTableViewWithArray:[responseObject objectForKey:@"data"]];
                                    }
    }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    NSLog(@"%@", error);
    }];
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] > 0) {
        if (_isRefreshing) {
            _isRefreshing = NO;
            [_serviceList removeAllObjects];
            [self.tableView reloadData];
        }
        
        for (NSDictionary *item in array) {
            [_serviceList addObject:item];
        }
        [self.tableView reloadData];
    }
    
    if ([_serviceList count] == 0) {
        _noaccessView.hidden = NO;
    }else {
        _noaccessView.hidden = YES;
    }
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    [self refresh];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    [self loadMore];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_serviceList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SWIDTH*0.35+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *serviceData = [_serviceList objectAtIndex:indexPath.row];
    ServiceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    [cell setImageWidth:SWIDTH*0.35];
    [cell setServiceData:serviceData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *serviceData = [_serviceList objectAtIndex:indexPath.row];
    ServiceDetailViewController *detailView = [[ServiceDetailViewController alloc] init];
    detailView.serviceID = [[serviceData objectForKey:@"id"] integerValue];
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

@end

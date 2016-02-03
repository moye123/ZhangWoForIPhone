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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ServiceItemCell class] forCellReuseIdentifier:@"serviceCell"];
    
    _noaccessView.hidden = YES;
    _noaccessView.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:_noaccessView];
    
    [self didStartRefreshing:nil];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    
}

#pragma mark - download data

- (void)loadDataSource{
    [[DSXHttpManager sharedManager] GET:@"&c=service&a=showlist" parameters:@{@"catid":@(_catid),@"page":@(self.currentPage)}
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                                            self.moreData = [responseObject objectForKey:@"data"];
                                            if ([self.moreData count] > 0) {
                                                if (self.isRefreshing) {
                                                    self.isRefreshing = NO;
                                                    [self.dataList removeAllObjects];
                                                    [self.tableView reloadData];
                                                }
                                                
                                                for (NSDictionary *item in self.moreData) {
                                                    [self.dataList addObject:item];
                                                }
                                                [self.tableView reloadData];
                                            }
                                        }
                                    }
    }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    NSLog(@"%@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SWIDTH*0.35+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *serviceData = [self.dataList objectAtIndex:indexPath.row];
    ServiceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    [cell setImageWidth:SWIDTH*0.35];
    [cell setServiceData:serviceData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *serviceData = [self.dataList objectAtIndex:indexPath.row];
    ServiceDetailViewController *detailView = [[ServiceDetailViewController alloc] init];
    detailView.serviceID = [[serviceData objectForKey:@"id"] integerValue];
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
}

@end

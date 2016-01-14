//
//  SearchViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsDetailViewController.h"
#import "NewsDetailViewController.h"
#import "TravelDetailViewController.h"

@implementation SearchViewController
@synthesize dataList = _dataList;
@synthesize searchBar = _searchBar;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.barTintColor = [UIColor redColor];
    [_searchBar becomeFirstResponder];
    self.navigationItem.titleView = _searchBar;
    
    for (UIView *subview in _searchBar.subviews) {
        for (UIView *view in subview.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
                //NSLog(@"%@",view);
            }
        }
    }
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.searchResultsTableView.backgroundColor = [UIColor grayColor];
}

- (void)search{
    NSString *str = _searchBar.text;
    [[AFHTTPSessionManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=search"] parameters:@{@"keywords":str} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _dataList = responseObject;
            [self.tableView reloadData];
            if ([_dataList count] == 0) {
                [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"没有查询到结果"];
            }
        }else {
            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleDefault Message:@"网络连接失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (tableView == self.tableView) {
        NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
        cell.textLabel.text = [data objectForKey:@"title"];
    }else {
        //cell.textLabel.text = @"2222222";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *data = [_dataList objectAtIndex:indexPath.row];
    NSString *idType = [data objectForKey:@"idtype"];
    
    if ([idType isEqualToString:@"aid"]) {
        NewsDetailViewController *newsView = [[NewsDetailViewController alloc] init];
        newsView.newsID = [[data objectForKey:@"dataid"] integerValue];
        [self.navigationController pushViewController:newsView animated:YES];
    }
    
    if ([idType isEqualToString:@"goodsid"]) {
        GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
        goodsView.goodsid = [[data objectForKey:@"dataid"] integerValue];
        [self.navigationController pushViewController:goodsView animated:YES];
    }
    
    if ([idType isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelView = [[TravelDetailViewController alloc] init];
        travelView.travelID = [[data objectForKey:@"dataid"] integerValue];
        [self.navigationController pushViewController:travelView animated:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [self search];
}

@end

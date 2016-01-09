//
//  MyFavoriteViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "NewsDetailViewController.h"
#import "TravelDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ChaoshiViewController.h"
#import "ChaoshiDetailViewController.h"

@implementation MyFavoriteViewController
@synthesize favoriteList = _favoriteList;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收藏"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _favoriteList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor backColor];
    [self.tableView registerClass:[FavorItemCell class] forCellReuseIdentifier:@"favorCell"];
    
    _refreshContorl = [[ZWRefreshControl alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    [_refreshContorl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    _pullUpView = [[ZWPullUpView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _pullUpView.hidden = YES;
    self.refreshControl = _refreshContorl;
    self.tableView.tableFooterView = _pullUpView;
    [self refresh];
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
    [[AFHTTPRequestOperationManager sharedManager] GET:[SITEAPI stringByAppendingFormat:@"&c=favorite&a=showlist&page=%d&uid=%ld",_page,(long)[ZWUserStatus sharedStatus].uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:responseObject];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SWIDTH*0.37+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *favorItem = [_favoriteList objectAtIndex:indexPath.row];
    NSDictionary *favorData = [favorItem objectForKey:@"data"];
    FavorItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    [cell setIdType:[favorItem objectForKey:@"idtype"]];
    [cell.timeLabel setText:[favorItem objectForKey:@"dateline"]];
    [cell setFavorData:favorData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *favorItem = [_favoriteList objectAtIndex:indexPath.row];
    NSString *idType = [favorItem objectForKey:@"idtype"];
    if ([idType isEqualToString:@"aid"]) {
        NewsDetailViewController *newsView = [[NewsDetailViewController alloc] init];
        newsView.newsID = [[favorItem objectForKey:@"dataid"] integerValue];
        newsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsView animated:YES];
    }
    
    if ([idType isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelView = [[TravelDetailViewController alloc] init];
        travelView.travelID = [[favorItem objectForKey:@"dataid"] integerValue];
        [self.navigationController pushViewController:travelView animated:YES];
    }
    
    if ([idType isEqualToString:@"goodsid"]) {
        GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
        goodsView.goodsid = [[favorItem objectForKey:@"dataid"] integerValue];
        goodsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsView animated:YES];
    }
    
    if ([idType isEqualToString:@"shopid"]) {
        ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
        shopView.shopid = [[favorItem objectForKey:@"dataid"] integerValue];
        [self.navigationController pushViewController:shopView animated:YES];
    }
    
    if ([idType isEqualToString:@"csgoodsid"]) {
        ChaoshiDetailViewController *csdetailView = [[ChaoshiDetailViewController alloc] init];
        csdetailView.goodsid = [[favorItem objectForKey:@"dataid"] integerValue];
        csdetailView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:csdetailView animated:YES];
    }
    
    if ([idType isEqualToString:@"chaoshiid"]) {
        ChaoshiViewController *chaoshiView = [[ChaoshiViewController alloc] init];
        chaoshiView.shopid = [[favorItem objectForKey:@"dataid"] integerValue];
        [self.navigationController pushViewController:chaoshiView animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *favorItem = [_favoriteList objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger favid = [[favorItem objectForKey:@"favid"] integerValue];
        NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),@"favid":@(favid)};
        [[AFHTTPRequestOperationManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=favorite&a=delete"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [_favoriteList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
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

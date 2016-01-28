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
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, SWIDTH, 40)];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _toolbar;
    //[self.navigationController.view addSubview:_toolbar];
    
    UIBarButtonItem *goodsItem = [[UIBarButtonItem alloc] initWithTitle:@"商品" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *shopItem = [[UIBarButtonItem alloc] initWithTitle:@"店铺" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *articleItem = [[UIBarButtonItem alloc] initWithTitle:@"文章" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *travelItem = [[UIBarButtonItem alloc] initWithTitle:@"景点" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *separater = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_toolbar setItems:@[separater,goodsItem,separater,shopItem,separater,articleItem,separater,travelItem,separater]];
    
    _favoriteList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor backColor];
    [self.tableView registerClass:[FavorItemCell class] forCellReuseIdentifier:@"favorCell"];
    
    DSXRefreshControl *refreshControl = [[DSXRefreshControl alloc] initWithScrollView:self.tableView];
    refreshControl.delegate = self;
    [self refresh];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _toolbar.hidden = YES;
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
    [[DSXHttpManager sharedManager] GET:@"&c=favorite&a=showlist"
                             parameters:@{@"uid":@([ZWUserStatus sharedStatus].uid),@"page":@(_page)}
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
            [_favoriteList removeAllObjects];
            [self.tableView reloadData];
        }
        for (NSDictionary *dict in array) {
            [_favoriteList addObject:dict];
        }
        [self.tableView reloadData];
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
        [[DSXHttpManager sharedManager] GET:@"&c=favorite&a=delete" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [_favoriteList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

@end

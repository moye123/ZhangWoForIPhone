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

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收藏"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 30)];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.tintColor = [UIColor blackColor];
    _toolbar.clipsToBounds = YES;
    self.navigationItem.titleView = _toolbar;
    //[self.navigationController.view addSubview:_toolbar];
    
    UIBarButtonItem *goodsItem = [[UIBarButtonItem alloc] initWithTitle:@"商品" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *shopItem = [[UIBarButtonItem alloc] initWithTitle:@"店铺" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *articleItem = [[UIBarButtonItem alloc] initWithTitle:@"文章" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *travelItem = [[UIBarButtonItem alloc] initWithTitle:@"景点" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *separater = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_toolbar setItems:@[goodsItem,separater,shopItem,separater,articleItem,separater,travelItem]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FavorItemCell class] forCellReuseIdentifier:@"favorCell"];
    
    [self didStartRefreshing:nil];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - refresh delegate
- (void)didStartRefreshing:(DSXRefreshView *)refreshView{
    self.currentPage = 1;
    self.isRefreshing = YES;
    [self loadDataSource];
}

- (void)didStartLoading:(DSXRefreshView *)refreshView{
    self.currentPage++;
    self.isRefreshing = NO;
    [self loadDataSource];
}

#pragma mark - loadDataSource

- (void)loadDataSource{
    [[DSXHttpManager sharedManager] GET:@"&c=favorite&a=showlist"
                             parameters:@{@"uid":@([ZWUserStatus sharedStatus].uid),@"page":@(self.currentPage)}
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
                                                for (NSDictionary *dict in self.moreData) {
                                                    [self.dataList addObject:dict];
                                                }
                                                [self.tableView reloadData];
                                            }
                                        }
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    return SWIDTH*0.37+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *favorItem = [self.dataList objectAtIndex:indexPath.row];
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
    NSDictionary *favorItem = [self.dataList objectAtIndex:indexPath.row];
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
    NSDictionary *favorItem = [self.dataList objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger favid = [[favorItem objectForKey:@"favid"] integerValue];
        NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),@"favid":@(favid)};
        [[DSXHttpManager sharedManager] GET:@"&c=favorite&a=delete" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self.dataList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

@end

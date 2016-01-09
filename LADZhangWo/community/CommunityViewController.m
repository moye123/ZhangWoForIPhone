//
//  CommunityViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CommunityViewController.h"
#import "ShopDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "NewsDetailViewController.h"
#import "TravelDetailViewController.h"
#import "ShopListViewController.h"

@implementation CommunityViewController
@synthesize tableView = _tableView;
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"智慧社区"];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    CGRect frame = self.view.bounds;
    frame.size.height-= 50;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"categoryCell"];
    [_tableView registerClass:[ShopItemCell class] forCellReuseIdentifier:@"shopItemCell"];
    [self.view addSubview:_tableView];
    
    _sliderView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    _sliderView.num = 3;
    _sliderView.groupid = 1;
    _sliderView.delegate = self;
    [_sliderView loaddata];
    [_tableView setTableHeaderView:_sliderView];
    
    //板块分类
    NSString *path = [[NSBundle mainBundle] pathForResource:@"communitycategory" ofType:@"plist"];
    _categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 100)];
    _categoryView.cellSize  = CGSizeMake(SWIDTH/3, 100);
    _categoryView.imageSize = CGSizeMake(50, 50);
    _categoryView.categoryData = [NSArray arrayWithContentsOfFile:path];
    _categoryView.touchDelegate = self;
    
    [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=shop&a=showlist&pagesize=10"] parameters:[DSXUtil getLocation] success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _shopList = responseObject;
            //NSLog(@"%@",_shopList);
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - category view delegate
- (void)categoryView:(CategoryView *)categoryView didSelectedItemAt:(NSIndexPath *)indexPath data:(NSDictionary *)data{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开放" message:@"此版块暂未开放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        return [_shopList count]+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 50;
        }else {
            return 120;
        }
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:_categoryView];
        return cell;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
            }
            cell.textLabel.text = @"附近商家";
            cell.detailTextLabel.text = @"查看更多信息";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else {
            ShopItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopItemCell"];
            NSDictionary *shopData = [_shopList objectAtIndex:(indexPath.row-1)];
            [cell setShopData:shopData];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ShopListViewController *listView = [[ShopListViewController alloc] init];
            [self.navigationController pushViewController:listView animated:YES];
        }else {
            NSDictionary *shopData = [_shopList objectAtIndex:(indexPath.row-1)];
            ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
            shopView.shopid = [[shopData objectForKey:@"shopid"] integerValue];
            [self.navigationController pushViewController:shopView animated:YES];
        }
    }
}

#pragma mark - sliderView delegate
- (void)slideView:(DSXSliderView *)slideView touchedImageWithDataID:(NSInteger)dataID idType:(NSString *)idType{
    if ([idType isEqualToString:@"goodsid"]) {
        GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
        goodsView.goodsid = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:NO completion:nil];
    }
    
    if ([idType isEqualToString:@"aid"]) {
        NewsDetailViewController *newsView = [[NewsDetailViewController alloc] init];
        newsView.newsID = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:newsView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idType isEqualToString:@"shopid"]) {
        ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
        shopView.shopid = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:shopView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idType isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelView = [[TravelDetailViewController alloc] init];
        travelView.travelID = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:travelView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

@end

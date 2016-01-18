//
//  ServiceViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ServiceViewController.h"
#import "NewsDetailViewController.h"
#import "TravelDetailViewController.h"
#import "ShopDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "ServiceListViewController.h"
#import "MyMessageViewController.h"
#import "MyFavoriteViewController.h"
#import "ShopListViewController.h"


@implementation ServiceViewController
@synthesize serviceList = _serviceList;
@synthesize tableView   = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"生活服务"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    CGRect frame = self.view.bounds;
    frame.size.height-= 60;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ShopItemCell class] forCellReuseIdentifier:@"shopItemCell"];
    [_tableView registerClass:[TitleCell class] forCellReuseIdentifier:@"titleCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"categoryCell"];
    
    //轮播广告
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 180)];
    _slideView.groupid = 9;
    _slideView.num = 3;
    _slideView.delegate = self;
    [_slideView loaddata];
    [_tableView setTableHeaderView:_slideView];
    
    _categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 10, SWIDTH, 270)];
    _categoryView.cellSize  = CGSizeMake(SWIDTH/4, 90);
    _categoryView.imageSize = CGSizeMake(50, 50);
    _categoryView.scrollEnabled = NO;
    _categoryView.touchDelegate = self;
    
    _serviceList = [NSMutableArray array];
    [[AFHTTPSessionManager sharedManager] GET:[SITEAPI stringByAppendingString:@"&c=service&a=category"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _serviceList = responseObject;
            _categoryView.dataList = _serviceList;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //加载商家列表
    NSDictionary *coordinateParam = [DSXUtil getLocation];
    [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=shop&a=showlist&pagesize=10"] parameters:coordinateParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _shopList = responseObject;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showPopMenu{
    [_popMenu toggle];
}

- (void)dropDownMenu:(DSXDropDownMenu *)dropDownMenu didSelectedAtCellItem:(UITableViewCell *)cellItem withData:(NSDictionary *)data{
    [dropDownMenu slideUp];
    NSString *action = [data objectForKey:@"action"];
    if ([action isEqualToString:@"shownotice"]) {
        MyMessageViewController *messageView = [[MyMessageViewController alloc] init];
        [self.navigationController pushViewController:messageView animated:YES];
    }
    
    if ([action isEqualToString:@"showfavorite"]) {
        MyFavoriteViewController *favorView = [[MyFavoriteViewController alloc] init];
        [self.navigationController pushViewController:favorView animated:YES];
    }
    
    if ([action isEqualToString:@"showhome"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
}

#pragma mark - categoryView delegate
- (void)categoryView:(CategoryView *)categoryView didSelectedAtItemWithData:(NSDictionary *)data{
    ServiceListViewController *listView = [[ServiceListViewController alloc] init];
    listView.catid = [[data objectForKey:@"catid"] integerValue];
    listView.title = [data objectForKey:@"cname"];
    [self.navigationController pushViewController:listView animated:YES];
    
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
        return 290;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return 110;
        }
    }else {
        return 45;
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
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            cell.textLabel.text = @"附近商家";
            cell.detailTextLabel.text = @"查看更多信息";
            cell.image  = [UIImage imageNamed:@"icon-hot.png"];
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
            ShopListViewController *shopView = [[ShopListViewController alloc] init];
            [self.navigationController pushViewController:shopView animated:YES];
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

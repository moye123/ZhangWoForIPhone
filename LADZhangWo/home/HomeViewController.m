//
//  HomeViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "TravelViewController.h"
#import "TravelDetailViewController.h"
#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "ChaoshiIndexViewController.h"
#import "ChaoshiCatViewController.h"
#import "ServiceViewController.h"
#import "ShopDetailViewController.h"
#import "WebViewController.h"
#import "SearchViewController.h"
#import "MyMessageViewController.h"
#import "CommunityViewController.h"
#import "TechanViewController.h"

@implementation HomeViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    
    UITapGestureRecognizer *localTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDistrict)];
    _localView = [[localView alloc] initWithFrame:CGRectMake(0, 29, 60, 29)];
    [_localView addGestureRecognizer:localTap];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:_localView];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    _searchView = [[HomeSearchView alloc] initWithFrame:CGRectMake(0, 0, 280, 29)];
    _searchView.textField.delegate = self;
    self.navigationItem.titleView = _searchView;
    
    UIBarButtonItem *moreButton = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showMessage)];
    self.navigationItem.rightBarButtonItem = moreButton;
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 64, 100, 140)];
    [self.navigationController.view addSubview:_popMenu];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[TitleCell class] forCellReuseIdentifier:@"titleCell"];
    [_tableView registerClass:[GoodsItemCell class] forCellReuseIdentifier:@"goodsCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"channelCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shopCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"travelCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"specialCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"foodCell"];
    
    //轮播广告
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 310, SWIDTH, SWIDTH*0.5)];
    _slideView.groupid = 13;
    _slideView.num = 6;
    _slideView.delegate = self;
    [_slideView loaddata];
    [_tableView setTableHeaderView:_slideView];
    
    //分类列表
    _channelView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 180)];
    _channelView.contentSize = CGSizeMake(SWIDTH, 0);
    _channelView.cellSize = CGSizeMake(SWIDTH/4, 90);
    _channelView.imageSize = CGSizeMake(50, 50);
    _channelView.touchDelegate = self;
    _channelView.dataList = [[NSUserDefaults standardUserDefaults] arrayForKey:@"channellist"];
    [[DSXHttpManager sharedManager] GET:@"&c=channel" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSArray *array = [responseObject objectForKey:@"data"];
                _channelView.dataList = array;
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"channellist"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //推荐商家
    _shopSlideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SWIDTH*0.33)];
    _shopSlideView.delegate = self;
    _shopSlideView.groupid = 14;
    _shopSlideView.num = 5;
    _shopSlideView.pageControl.hidden = YES;
    [_shopSlideView loaddata];
    
    //本地旅游
    _travelSliderView = [[TravelSliderView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 750)];
    _travelSliderView.touchDelegate = self;
    _travelSliderView.cellSize = CGSizeMake(SWIDTH-0.001, 250);
    _travelSliderView.contentSize = CGSizeMake(SWIDTH*2, 0);
    _travelSliderView.collectionView.frame = CGRectMake(0, 0, SWIDTH*2, 750);
    [[DSXHttpManager sharedManager] GET:@"&c=ad&a=showlist&groupid=15&num=9" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSArray *array = [responseObject objectForKey:@"data"];
                _travelSliderView.dataList = array;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //特色产品推荐
    CGSize goodsCellSize = CGSizeMake((SWIDTH-10)/3, (SWIDTH-40)/3);
    _specialGoodsView = [[SliderView alloc] initWithFrame:CGRectMake(5, 0, SWIDTH-10, goodsCellSize.height)];
    _specialGoodsView.touchDelegate = self;
    _specialGoodsView.cellSize = goodsCellSize;
    _specialGoodsView.imageSize = CGSizeMake(goodsCellSize.width-10, goodsCellSize.height);
    _specialGoodsView.contentSize = CGSizeMake((SWIDTH-10)*3, 0);
    _specialGoodsView.collectionView.frame = CGRectMake(0, 0, _specialGoodsView.frame.size.width*3, goodsCellSize.height);
    [[DSXHttpManager sharedManager] GET:@"&c=ad&a=showlist&groupid=16&num=6" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                NSArray *array = [responseObject objectForKey:@"data"];
                _specialGoodsView.dataList = array;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //特色美食
    CGSize cellSize = CGSizeMake((SWIDTH-10)/3, (SWIDTH-10)/3);
    _foodGalleryView = [[GalleryView alloc] initWithFrame:CGRectMake(5, 0, SWIDTH-10, cellSize.height*2)];
    _foodGalleryView.cellSize = cellSize;
    _foodGalleryView.imageSize = CGSizeMake(cellSize.width-10, cellSize.height-10);
    _foodGalleryView.scrollEnabled = NO;
    _foodGalleryView.touchDelegate = self;
    
    [[DSXHttpManager sharedManager] GET:@"&c=ad&a=showlist&groupid=17&num=6" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _foodGalleryView.dataList = [responseObject objectForKey:@"data"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    //猜你喜欢
    [[DSXHttpManager sharedManager] GET:@"&c=goods&a=showlist&pagesize=10"
                             parameters:nil progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _goodsList = [responseObject objectForKey:@"data"];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:5]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)showMessage{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        MyMessageViewController *messageView = [[MyMessageViewController alloc] init];
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:messageView];
        [nav setStyle:ZWNavigationStyleGray];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        [[ZWUserStatus sharedStatus] showLoginFromViewController:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SearchViewController *searchView = [[SearchViewController alloc] init];
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:searchView];
    [nav setStyle:ZWNavigationStyleGray];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
}

#pragma mark - slider view delegate
- (void)sliderView:(SliderView *)sliderView didSelectedItemWithData:(NSDictionary *)data{
    [[ShowAdModel sharedModel] presentWithData:data fromViewController:self.navigationController];
}

- (void)DSXSliderView:(DSXSliderView *)sliderView didSelectedItemWithData:(NSDictionary *)data{
    [[ShowAdModel sharedModel] presentWithData:data fromViewController:self.navigationController];
}

#pragma mark - travel view delegate
- (void)travelView:(TravelSliderView *)travelView didSelectedItemWithData:(NSDictionary *)data{
    [[ShowAdModel sharedModel] presentWithData:data fromViewController:self.navigationController];
}

#pragma mark - gallery view delegate
- (void)galleryView:(GalleryView *)galleryView didSelectedItemWithData:(NSDictionary *)data{
    [[ShowAdModel sharedModel] presentWithData:data fromViewController:self.navigationController];
}

#pragma mark - categoryView delegate
- (void)categoryView:(CategoryView *)categoryView didSelectedAtItemWithData:(NSDictionary *)data{
    NSString *catid = [data objectForKey:@"catid"];
    //旅游
    if ([catid isEqualToString:@"travel"]) {
        TravelViewController *travelController = [[TravelViewController alloc] init];
        ZWNavigationController *travelNav = [[ZWNavigationController alloc] initWithRootViewController:travelController];
        travelNav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:travelNav animated:YES completion:nil];
    }
    
    //资讯
    if ([catid isEqualToString:@"news"]) {
        NewsViewController *newsController = [[NewsViewController alloc] init];
        ZWNavigationController *newsNav = [[ZWNavigationController alloc] initWithRootViewController:newsController];
        newsNav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:newsNav animated:YES completion:nil];
    }
    
    //超市
    if ([catid isEqualToString:@"market"]) {
        ChaoshiIndexViewController *chaoshiView = [[ChaoshiIndexViewController alloc] init];
        //ChaoshiCatViewController *chaoshiView = [[ChaoshiCatViewController alloc] init];
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:chaoshiView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    //名优特产
    if ([catid isEqualToString:@"product"]) {
        TechanViewController *techanView = [[TechanViewController alloc] init];
        [self.navigationController pushViewController:techanView animated:YES];
    }
    
    //特色小吃
    if ([catid isEqualToString:@"snack"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 18;
        goodsListController.title = @"特色小吃";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    //外卖
    if ([catid isEqualToString:@"takeout"]) {
        CommunityViewController *communityView = [[CommunityViewController alloc] init];
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:communityView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([catid isEqualToString:@"food"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"美食";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([catid isEqualToString:@"service"]) {
        ServiceViewController *serviceView = [[ServiceViewController alloc] init];
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:serviceView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
    [self.navigationController.view resignFirstResponder];
}


- (void)showDistrict{
    DistrictViewController *districtController = [[DistrictViewController alloc] init];
    districtController.delegate = self;
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:districtController];
    nav.style = ZWNavigationStyleGray;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
- (void)locationChangeWithName:(NSString *)name{
    _localView.textLabel.text = name;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 5){
        return [_goodsList count]+1;
    }else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 190;
    }else if (indexPath.section == 1){
        return _shopSlideView.frame.size.height;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return _travelSliderView.frame.size.height+2;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 45;
        }else {
            //特色产品
            return _specialGoodsView.frame.size.height+5;
        }
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return _foodGalleryView.frame.size.height+5;
        }
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return SWIDTH*0.30+10;
        }
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell addSubview:_channelView];
        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell addSubview:_shopSlideView];
        }
        return cell;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.title  = @"旅游景点推荐";
            cell.detail = @"查看更多";
            cell.image  = [UIImage imageNamed:@"icon-hot.png"];
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"travelCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:_travelSliderView];
            return cell;
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.title  = @"本地特产";
            cell.detail = @"查看更多";
            cell.image  = [UIImage imageNamed:@"icon-hot.png"];
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specialCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:_specialGoodsView];
            return cell;
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            cell.title  = @"特色美食推荐";
            cell.detail = @"查看更多";
            cell.image  = [UIImage imageNamed:@"icon-hot.png"];
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:_foodGalleryView];
            return cell;
        }
    }
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            cell.title  = @"猜你喜欢";
            cell.detail = @"查看更多";
            cell.image  = [UIImage imageNamed:@"icon-hot.png"];
            return cell;
        }else {
            NSDictionary *goodsData = [_goodsList objectAtIndex:(indexPath.row - 1)];
            GoodsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
            cell.goodsData  = goodsData;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TravelViewController *travelView = [[TravelViewController alloc] init];
            ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:travelView];
            nav.style = ZWNavigationStyleGray;
            [self.navigationController presentViewController:nav animated:YES  completion:nil];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            GoodsListViewController *listView = [[GoodsListViewController alloc] init];
            listView.catid = 17;
            listView.title = @"本地特产";
            ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:listView];
            nav.style = ZWNavigationStyleGray;
            [self.navigationController presentViewController:nav animated:YES  completion:nil];
        }
    }
    
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            GoodsListViewController *listView = [[GoodsListViewController alloc] init];
            listView.catid = 1;
            listView.title = @"本地美食";
            ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:listView];
            nav.style = ZWNavigationStyleGray;
            [self.navigationController presentViewController:nav animated:YES  completion:nil];
        }
    }
    
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            GoodsListViewController *listView = [[GoodsListViewController alloc] init];
            listView.catid = 0;
            listView.title = @"本地热卖";
            ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:listView];
            nav.style = ZWNavigationStyleGray;
            [self.navigationController presentViewController:nav animated:YES  completion:nil];
            
        }else {
            NSDictionary *goodsData = [_goodsList objectAtIndex:(indexPath.row - 1)];
            GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
            goodsView.goodsid = [[goodsData objectForKey:@"id"] intValue];
            ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsView];
            nav.style = ZWNavigationStyleGray;
            [self.navigationController presentViewController:nav animated:YES  completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end

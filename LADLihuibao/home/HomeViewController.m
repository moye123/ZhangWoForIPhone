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

@implementation HomeViewController
@synthesize local;
@synthesize tableView = _tableView;
@synthesize categoryView = _categoryView;
@synthesize businessView = _businessView;
@synthesize travelView = _travelView;
@synthesize productView = _productView;
@synthesize foodView = _foodView;

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    
    UITapGestureRecognizer *localTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDistrict)];
    self.local = [[localView alloc] initWithFrame:CGRectMake(0, 29, 60, 29)];
    [self.local addGestureRecognizer:localTap];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.local];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    searchBar *search = [[searchBar alloc] initWithFrame:CGRectMake(0, 0, 280, 29)];
    search.textField.enabled = NO;
    self.navigationItem.titleView = search;
    
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMoreWhite target:self action:nil];
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height - 54;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //分类列表
    _categoryView = [[HomeCategoryView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    _categoryView.categoryDelegate = self;
    
    //推荐商家
    _businessView = [[RecommendSliderView alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 80)];
    _businessView.tapDelegate = self;
    _businessView.groupid = 1;
    _businessView.dataCount = 9;
    _businessView.imgWidth = (SWIDTH-40)/3;
    _businessView.imgHeight = 80;
    _businessView.contentSize = CGSizeMake((SWIDTH-20)*3, 0);
    [_businessView loadData];
    
    //旅游推荐
    _travelView = [[RecommendSliderView alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 100)];
    _travelView.tapDelegate = self;
    _travelView.groupid = 2;
    _travelView.dataCount = 6;
    _travelView.imgWidth = (SWIDTH-30)/2;
    _travelView.imgHeight = 100;
    _travelView.contentSize = CGSizeMake((SWIDTH-20)*3, 0);
    [_travelView loadData];
    
    //特色产品推荐
    _productView = [[RecommendSliderView alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 100)];
    _productView.tapDelegate = self;
    _productView.groupid = 3;
    _productView.dataCount = 6;
    _productView.imgWidth = (SWIDTH-20)/2;
    _productView.imgHeight = 100;
    _productView.contentSize = CGSizeMake((SWIDTH-20)*3, 0);
    [_productView loadData];
    
    //特色美食推荐
    _foodView = [[RecommendSliderView2 alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 140)];
    _foodView.tapDelegate = self;
    _foodView.groupid = 4;
    _foodView.dataCount = 6;
    _foodView.contentSize = CGSizeMake((SWIDTH-20)*2, 0);
    [_foodView loadData];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 210;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return 100;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return 110;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return 110;
        }
    }else {
        if (indexPath.row == 0) {
            return 45;
        }else {
            return 150;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell addSubview:_categoryView];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"特色商家推荐";
        }
        if (indexPath.row == 1) {
            [cell addSubview:_businessView];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"旅游景点推荐";
        }
        if (indexPath.row == 1) {
            [cell addSubview:_travelView];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"本地特产";
        }
        if (indexPath.row == 1) {
            [cell addSubview:_productView];
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"特色美食推荐";
        }
        if (indexPath.row == 1) {
            [cell addSubview:_foodView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark -
- (void)showCategoryWithTag:(NSString *)tag{
    //旅游
    if ([tag isEqualToString:@"travel"]) {
        TravelViewController *travelController = [[TravelViewController alloc] init];
        LHBNavigationController *travelNav = [[LHBNavigationController alloc] initWithRootViewController:travelController];
        [travelNav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:travelNav animated:YES completion:nil];
    }
    
    //资讯
    if ([tag isEqualToString:@"news"]) {
        NewsViewController *newsController = [[NewsViewController alloc] init];
        LHBNavigationController *newsNav = [[LHBNavigationController alloc] initWithRootViewController:newsController];
        [newsNav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:newsNav animated:YES completion:nil];
    }
    
    //超市
    if ([tag isEqualToString:@"market"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 3;
        goodsListController.title = @"生活超市";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    //名优特产
    if ([tag isEqualToString:@"product"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 17;
        goodsListController.title = @"名优特产";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    //特色小吃
    if ([tag isEqualToString:@"snack"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 18;
        goodsListController.title = @"特色小吃";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    //外卖
    if ([tag isEqualToString:@"takeout"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 19;
        goodsListController.title = @"我要外卖";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([tag isEqualToString:@"food"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"美食";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([tag isEqualToString:@"service"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"本地服务";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - recommend delegate
- (void)showDetailWithID:(NSInteger)ID andIdType:(NSString *)idtype{
    if ([idtype isEqualToString:@"shopid"]) {
        
    }
    
    if ([idtype isEqualToString:@"goodsid"]) {
        GoodsDetailViewController *goodsDetailView = [[GoodsDetailViewController alloc] init];
        goodsDetailView.goodsid = ID;
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsDetailView];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idtype isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelDetailView = [[TravelDetailViewController alloc] init];
        travelDetailView.travelID = ID;
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:travelDetailView];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idtype isEqualToString:@"aid"]) {
        NewsDetailViewController *newsDetailView = [[NewsDetailViewController alloc] init];
        newsDetailView.newsID = ID;
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:newsDetailView];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
    [self.navigationController.view resignFirstResponder];
}

- (void)clickShowMore{
    //[[DSXUI sharedUI] showLoginFromViewController:self];
}

- (void)showDistrict{
    DistrictViewController *districtController = [[DistrictViewController alloc] init];
    districtController.delegate = self;
    LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:districtController];
    [nav setNavigationStyle:LHBNavigationStyleGray];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 
- (void)locationChangeWithName:(NSString *)name{
    self.local.textLabel.text = name;
}

@end

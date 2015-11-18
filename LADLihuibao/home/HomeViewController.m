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
#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"

@implementation HomeViewController
@synthesize local;
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
    self.navigationItem.rightBarButtonItem.width = 29;
    
    //主体
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    CGFloat y;
    HomeCategoryView *categoryView = [[HomeCategoryView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    categoryView.categoryDelegate = self;
    [scrollView addSubview:categoryView];
    
    HomeFoodView *foodView = [[HomeFoodView alloc] initWithFrame:CGRectMake(0, 215, SWIDTH, 120)];
    foodView.delegate = self;
    [scrollView addSubview:foodView];
    
    y = foodView.frame.origin.y + foodView.frame.size.height + 10;
    HomeNewsView *newsView = [[HomeNewsView alloc] initWithFrame:CGRectMake(0, y, SWIDTH, 480)];
    newsView.delegate = self;
    [scrollView addSubview:newsView];
    
    [scrollView setContentSize:CGSizeMake(0, 720)];
    [self.view addSubview:scrollView];
}

- (void)showCategoryWithTag:(NSString *)tag{
    //旅游
    if ([tag isEqualToString:@"travel"]) {
        TravelViewController *travelController = [[TravelViewController alloc] init];
        LHBNavigationController *travelNav = [[LHBNavigationController alloc] initWithRootViewController:travelController];
        [travelNav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:travelNav animated:NO completion:nil];
    }
    
    //资讯
    if ([tag isEqualToString:@"news"]) {
        NewsViewController *newsController = [[NewsViewController alloc] init];
        LHBNavigationController *newsNav = [[LHBNavigationController alloc] initWithRootViewController:newsController];
        [newsNav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:newsNav animated:NO completion:nil];
    }
    
    //超市
    if ([tag isEqualToString:@"market"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 3;
        goodsListController.title = @"生活超市";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
    //名优特产
    if ([tag isEqualToString:@"product"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 17;
        goodsListController.title = @"名优特产";
        LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:goodsListController];
        [nav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:nav animated:NO completion:nil];
    }
    
    //特色小吃
    if ([tag isEqualToString:@"snack"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 18;
        goodsListController.title = @"特色小吃";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
    //外卖
    if ([tag isEqualToString:@"takeout"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 19;
        goodsListController.title = @"我要外卖";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
    if ([tag isEqualToString:@"food"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"美食";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
    if ([tag isEqualToString:@"service"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"本地服务";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
}

- (void)showNewsDetailWhithID:(NSInteger)newsID{
    NewsDetailViewController *detailView = [[NewsDetailViewController alloc] init];
    detailView.newsID = (int)newsID;
    detailView.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:detailView animated:YES];
    LHBNavigationController *nav = [[LHBNavigationController alloc] initWithRootViewController:detailView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showFoodDetailWithID:(NSInteger)foodID{
    GoodsDetailViewController *detailController = [[GoodsDetailViewController alloc] init];
    detailController.goodsid = foodID;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
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

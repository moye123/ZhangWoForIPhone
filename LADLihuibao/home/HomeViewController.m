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
#import "TravelListViewController.h"
#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"

@implementation HomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setPlaceholder:@"搜索商家，分类，地点"];
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor blackColor];

    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"六盘水" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(clickShowMore)];
    
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
    if ([tag isEqualToString:@"travel"]) {
        TravelListViewController *travelController = [[TravelListViewController alloc] init];
        LHBNavigationController *travelNav = [[LHBNavigationController alloc] initWithRootViewController:travelController];
        travelNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [travelNav setNavigationStyle:LHBNavigationStyleGray];
        [self presentViewController:travelNav animated:YES completion:nil];
    }
    if ([tag isEqualToString:@"news"]) {
        NewsViewController *newsController = [[NewsViewController alloc] init];
        LHBNavigationController *newsNav = [[LHBNavigationController alloc] initWithRootViewController:newsController];
        [newsNav setNavigationStyle:LHBNavigationStyleGray];
        [newsNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:newsNav animated:YES completion:nil];
    }
    
    if ([tag isEqualToString:@"market"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 3;
        goodsListController.title = @"生活超市";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
    if ([tag isEqualToString:@"product"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 17;
        goodsListController.title = @"名优特产";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
    if ([tag isEqualToString:@"snack"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 18;
        goodsListController.title = @"特色小吃";
        [self.navigationController pushViewController:goodsListController animated:YES];
    }
    
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
    LHBNavigationController2 *nav = [[LHBNavigationController2 alloc] initWithRootViewController:detailView];
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
}

- (void)clickShowMore{
    //[[DSXUI sharedUI] showLoginFromViewController:self];
}

@end

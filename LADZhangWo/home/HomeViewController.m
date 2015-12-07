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
#import "ChaoshiViewController.h"

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
    
    UIBarButtonItem *moreButton = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMoreWhite target:self action:@selector(showPopMenu)];
    self.navigationItem.rightBarButtonItem = moreButton;
    CGRect frame = self.view.bounds;
    frame.size.height = frame.size.height - 54;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //轮播广告
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 310, SWIDTH, 200)];
    _tableView.tableHeaderView = _slideView;
    _afmanager = [AFHTTPRequestOperationManager manager];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_afmanager GET:[SITEAPI stringByAppendingString:@"&mod=travel&ac=showlist&pagesize=3"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        id array = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *imageViews = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in array) {
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[dict objectForKey:@"pic"] placeholderImage:[UIImage imageNamed:@"placeholder600x300.png"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageViews addObject:imageView];
            }
            _slideView.imageViews = imageViews;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    //分类列表
    _categoryView = [[HomeCategoryView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    _categoryView.categoryDelegate = self;
    
    //推荐商家
    CGFloat height = (SWIDTH - 50)/3;
    _businessView = [[RecommendSliderView alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, height)];
    _businessView.tapDelegate = self;
    _businessView.groupid = 1;
    _businessView.dataCount = 9;
    _businessView.imgWidth = (SWIDTH-40)/3;
    _businessView.imgHeight = height;
    _businessView.contentSize = CGSizeMake((SWIDTH-20)*3, 0);
    [_businessView loadData];
    
    //旅游推荐
    height = (SWIDTH - 30)/2;
    _travelView = [[RecommendSliderView alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, height)];
    _travelView.tapDelegate = self;
    _travelView.groupid = 2;
    _travelView.dataCount = 6;
    _travelView.imgWidth = (SWIDTH-30)/2;
    _travelView.imgHeight = height;
    _travelView.contentSize = CGSizeMake((SWIDTH-20)*3, 0);
    [_travelView loadData];
    
    //特色产品推荐
    height = (SWIDTH - 30)/3;
    _productView = [[RecommendSliderView alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, height)];
    _productView.tapDelegate = self;
    _productView.groupid = 3;
    _productView.dataCount = 6;
    _productView.imgWidth = (SWIDTH-20)/2;
    _productView.imgHeight = height;
    _productView.contentSize = CGSizeMake((SWIDTH-20)*3, 0);
    [_productView loadData];
    
    //特色美食推荐
    _foodView = [[RecommendSliderView2 alloc] initWithFrame:CGRectMake(10, 0, SWIDTH-20, 140)];
    _foodView.tapDelegate = self;
    _foodView.groupid = 4;
    _foodView.dataCount = 6;
    _foodView.contentSize = CGSizeMake((SWIDTH-20)*2, 0);
    [_foodView loadData];
    
    _popMenu = [[DSXPopMenu alloc] init];
    _popMenu.frame = CGRectMake(SWIDTH-110, -150, 100, 150);
    _popMenu.hidden = YES;
    [self.navigationController.view insertSubview:_popMenu belowSubview:self.navigationController.navigationBar];
}

- (void)showPopMenu{
    [_popMenu toggle];
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
            return (SWIDTH - 50)/3 + 10;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return (SWIDTH-30)/2+10;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 45;
        }else {
            return ((SWIDTH - 30)/3) + 10;
        }
    }else {
        if (indexPath.row == 0) {
            return 45;
        }else {
            return (SWIDTH-30)/2;
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
        ZWNavigationController *travelNav = [[ZWNavigationController alloc] initWithRootViewController:travelController];
        travelNav.style = ZWNavigationStyleGray;
        [self presentViewController:travelNav animated:YES completion:nil];
    }
    
    //资讯
    if ([tag isEqualToString:@"news"]) {
        NewsViewController *newsController = [[NewsViewController alloc] init];
        ZWNavigationController *newsNav = [[ZWNavigationController alloc] initWithRootViewController:newsController];
        newsNav.style = ZWNavigationStyleGray;
        [self presentViewController:newsNav animated:YES completion:nil];
    }
    
    //超市
    if ([tag isEqualToString:@"market"]) {
        ChaoshiViewController *chaoshiController = [[ChaoshiViewController alloc] init];
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:chaoshiController];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    //名优特产
    if ([tag isEqualToString:@"product"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 17;
        goodsListController.title = @"名优特产";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    //特色小吃
    if ([tag isEqualToString:@"snack"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 18;
        goodsListController.title = @"特色小吃";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    //外卖
    if ([tag isEqualToString:@"takeout"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 19;
        goodsListController.title = @"我要外卖";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([tag isEqualToString:@"food"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"美食";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([tag isEqualToString:@"service"]) {
        GoodsListViewController *goodsListController = [[GoodsListViewController alloc] init];
        goodsListController.catid = 1;
        goodsListController.title = @"本地服务";
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsListController];
        nav.style = ZWNavigationStyleGray;
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
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsDetailView];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idtype isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelDetailView = [[TravelDetailViewController alloc] init];
        travelDetailView.travelID = ID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:travelDetailView];
        nav.style = ZWNavigationStyleGray;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idtype isEqualToString:@"aid"]) {
        NewsDetailViewController *newsDetailView = [[NewsDetailViewController alloc] init];
        newsDetailView.newsID = ID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:newsDetailView];
        nav.style = ZWNavigationStyleGray;
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
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:districtController];
    nav.style = ZWNavigationStyleGray;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 
- (void)locationChangeWithName:(NSString *)name{
    self.local.textLabel.text = name;
}

@end

//
//  IncomeViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeView.h"
#import "ContactusViewController.h"
#import "LoginViewController.h"
#import "GoodsDetailViewController.h"
#import "NewsDetailViewController.h"
#import "WebViewController.h"
#import "ShopDetailViewController.h"
#import "TravelDetailViewController.h"
#import "RechargeViewController.h"

@implementation IncomeViewController
@synthesize scrollView = _scrollView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"我的收益"];
    [self.navigationController.tabBarItem setTitle:@"收益"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    IncomeView *myIncomeView = [[IncomeView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    [self.scrollView addSubview:myIncomeView];
    
    //下载个人收益数据
    [[AFHTTPRequestOperationManager sharedManager] GET:[SITEAPI stringByAppendingFormat:@"&c=income&a=getdata&uid=%ld",(long)[ZWUserStatus sharedStatus].uid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.income = [responseObject objectForKey:@"income"];
            float income = [[responseObject objectForKey:@"income"] floatValue];
            myIncomeView.incomeLabel.text = [NSString stringWithFormat:@"￥: %.2f",income];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    //充值按钮
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rechargeButton setFrame:CGRectMake(20, 217, 80, 80)];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"icon-recharge.png"] forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(showRecharge) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:rechargeButton];
    
    //提现按钮
    UIButton *withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [withdrawalButton setFrame:CGRectMake((SWIDTH-80)/2, 217, 80, 80)];
    [withdrawalButton setBackgroundImage:[UIImage imageNamed:@"icon-withdrawal.png"] forState:UIControlStateNormal];
    [withdrawalButton addTarget:self action:@selector(withDrawal) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:withdrawalButton];
    
    //联系我们按钮
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setFrame:CGRectMake(SWIDTH-100, 217, 80, 80)];
    [contactButton setBackgroundImage:[UIImage imageNamed:@"icon-contact.png"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(showContactus) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:contactButton];
    
    //底部广告
    _slideView = [[DSXSliderView alloc] initWithFrame:CGRectMake(0, 310, SWIDTH, 150)];
    _slideView.groupid = 8;
    _slideView.num = 3;
    _slideView.delegate = self;
    [_slideView loaddata];
    [self.scrollView addSubview:_slideView];
    
    self.scrollView.contentSize = CGSizeMake(0, 460);
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
    [nav setStyle:ZWNavigationStyleDefault];
    [super viewWillAppear:animated];
}

- (void)slideView:(DSXSliderView *)slideView touchedImageWithDataID:(NSInteger)dataID idType:(NSString *)idType{
    if ([idType isEqualToString:@"goodsid"]) {
        GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
        goodsView.goodsid = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:goodsView];
        nav.style = ZWNavigationStyleGray;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idType isEqualToString:@"aid"]) {
        NewsDetailViewController *newsView = [[NewsDetailViewController alloc] init];
        newsView.newsID = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:newsView];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idType isEqualToString:@"shopid"]) {
        ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
        shopView.shopid = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:shopView];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
    if ([idType isEqualToString:@"travelid"]) {
        TravelDetailViewController *travelView = [[TravelDetailViewController alloc] init];
        travelView.travelID = dataID;
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:travelView];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)showContactus{
    ContactusViewController *contactController = [[ContactusViewController alloc] init];
    [self.navigationController pushViewController:contactController animated:YES];
}

- (void)showRecharge{
    RechargeViewController *rechargeView = [[RechargeViewController alloc] init];
    ZWNavigationController *nav = (ZWNavigationController *)self.navigationController;
    [nav setStyle:ZWNavigationStyleGray];
    [self.navigationController pushViewController:rechargeView animated:YES];
}

- (void)withDrawal{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尽请期待" message:@"提现功能暂未开放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end

//
//  ChaoshiDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChaoshiDetailViewController.h"
#import "MarkMapViewController.h"
#import "BuyViewController.h"
#import "MyMessageViewController.h"

@implementation ChaoshiDetailViewController
@synthesize goodsid = _goodsid;
@synthesize goodsData = _goodsData;
@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"宝贝详情"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    CGRect frame = self.view.bounds;
    frame.size.height-= 44;
    _webView = [[UIWebView alloc] initWithFrame:frame];
    _webView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _webView.delegate = self;
    _webView.hidden = YES;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    
    _loadingView = [[DSXUI sharedUI] showLoadingViewWithMessage:nil];
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=chaoshi&a=showdetail&id=%ld",(long)_goodsid];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [[AFHTTPRequestOperationManager sharedManager] GET:[urlString stringByAppendingString:@"&datatype=json"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _goodsData = responseObject;
                _webView.hidden = NO;
                [_loadingView removeFromSuperview];
            }else{
                [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"商品已下架"];
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(back) userInfo:nil repeats:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    CGRect bottomFrame = self.navigationController.toolbar.frame;
    _bottomView = [[GoodsBottomView alloc] initWithFrame:CGRectMake(0, 0, bottomFrame.size.width, bottomFrame.size.height)];
    [_bottomView.cartButton addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.buyButton addTarget:self action:@selector(AddOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_bottomView];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    _addCartView = [[AddToCartView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
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
        if ([[ZWUserStatus sharedStatus] isLogined]) {
            NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                                     @"username":[ZWUserStatus sharedStatus].username,
                                     @"dataid":@(_goodsid),
                                     @"idtype":@"csgoodsid",
                                     @"title":[_goodsData objectForKey:@"name"]};
            [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=favorite&a=save"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"收藏成功"];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
        }else {
            [[DSXUI sharedUI] showLoginFromViewController:self];
        }
    }
    
    if ([action isEqualToString:@"showhome"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
}

#pragma mark -----------

- (void)addToCart{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        if (_goodsData) {
            _addCartView.goodsData = _goodsData;
            [_addCartView show];
        }
    }
    else {
        [[DSXUI sharedUI] showLoginFromViewController:self];
    }
}

- (void)AddOrder{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        BuyViewController *buyView = [[BuyViewController alloc] init];
        buyView.goodsid = _goodsid;
        buyView.from = @"chaoshi";
        [self.navigationController pushViewController:buyView animated:YES];
    }
    else {
        [[DSXUI sharedUI] showLoginFromViewController:self];
    }
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"请检查网络链接"];
    //NSLog(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSDictionary *params = [[DSXUtil sharedUtil] parseQueryString:[url query]];
    if ([[url scheme] isEqualToString:@"zwapp"]) {
        NSString *cmd = [url host];
        if ([cmd isEqualToString:@"buy"]) {
            BuyViewController *buyView = [[BuyViewController alloc] init];
            buyView.goodsid = [[params objectForKey:@"id"] integerValue];
            buyView.goodsdata = _goodsData;
            [self.navigationController pushViewController:buyView animated:YES];
        }
        
        if ([cmd isEqualToString:@"showmap"]) {
            MarkMapViewController *mapView = [[MarkMapViewController alloc] init];
            mapView.address = [params objectForKey:@"address"];
            [self.navigationController pushViewController:mapView animated:YES];
        }
    }
    return YES;
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.navigationController.toolbarHidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.navigationController.toolbarHidden = NO;
}

@end

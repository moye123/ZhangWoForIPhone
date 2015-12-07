//
//  GoodsDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "MarkMapViewController.h"
#import "BuyViewController.h"

@implementation GoodsDetailViewController
@synthesize goodsid;
@synthesize goodsdata = _goodsdata;
@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"宝贝详情"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    
    CGRect bottomFrame = self.navigationController.toolbar.frame;
    _bottomView = [[GoodsBottomView alloc] initWithFrame:CGRectMake(0, 0, bottomFrame.size.width, bottomFrame.size.height)];
    [_bottomView.cartButton addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.buyButton addTarget:self action:@selector(AddOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_bottomView];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    _addCartView = [[AddToCartView alloc] init];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=goods&ac=showdetail&id=%ld",(long)self.goodsid];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showLogin{
    [[DSXUI sharedUI] showLoginFromViewController:self];
}

- (void)addToCart{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@([[ZWUserStatus sharedStatus] uid]) forKey:@"uid"];
        [params setObject:[[ZWUserStatus sharedStatus] username] forKey:@"username"];
        
        if (!_addCartView.goodsData) {
            _addCartView.goodsData = _goodsdata;
        }
        if (_addCartView.goodsData) {
            [_addCartView show];
        }
    }
    else{
        [self showLogin];
    }
    
}

- (void)AddOrder{
    if ([[ZWUserStatus sharedStatus] isLogined]) {
        BuyViewController *buyView = [[BuyViewController alloc] init];
        buyView.goodsid = self.goodsid;
        [self.navigationController pushViewController:buyView animated:YES];
    }else {
        [self showLogin];
    }
    
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *jsonString = [webView stringByEvaluatingJavaScriptFromString:@"getGoods()"];
    id dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self.goodsdata = dictionary;
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"请检查网络链接"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSDictionary *params = [[DSXUtil sharedUtil] parseQueryString:[url query]];
    if ([[url scheme] isEqualToString:@"zwapp"]) {
        NSString *cmd = [url host];
        if ([cmd isEqualToString:@"buy"]) {
            [self AddOrder];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

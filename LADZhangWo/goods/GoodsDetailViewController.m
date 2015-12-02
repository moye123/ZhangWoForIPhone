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
@synthesize contentWebView = _contentWebView;
@synthesize userStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"宝贝详情"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    self.userStatus = [ZWUserStatus status];
    _contentWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _contentWebView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _contentWebView.delegate = self;
    _contentWebView.scrollView.delegate = self;
    [self.view addSubview:_contentWebView];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=goods&ac=showdetail&id=%d",self.goodsid];
    [_contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    _addToCart = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SWIDTH/2, 44)];
    [_addToCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_addToCart setBackgroundColor:[UIColor colorWithHexString:@"0xd47026"]];
    [_addToCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addToCart addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_addToCart];
    
    _buyNow = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH/2, 0, SWIDTH/2, 44)];
    [_buyNow setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyNow setBackgroundColor:[UIColor colorWithHexString:@"0xd51655"]];
    [_buyNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyNow addTarget:self action:@selector(AddOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_buyNow];
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showLogin{
    [[DSXUI sharedUI] showLoginFromViewController:self];
}

- (void)addToCart{
    if (self.userStatus.isLogined) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(self.userStatus.uid) forKey:@"uid"];
        [params setObject:self.userStatus.username forKey:@"username"];
        
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
    if (self.userStatus.isLogined) {
        BuyViewController *buyView = [[BuyViewController alloc] init];
        buyView.goodsid = self.goodsid;
        [self.navigationController pushViewController:buyView animated:YES];
    }else {
        [self showLogin];
    }
    
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *jsonString = [_contentWebView stringByEvaluatingJavaScriptFromString:@"getGoods()"];
    id dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self.goodsdata = dictionary;
        
    }
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

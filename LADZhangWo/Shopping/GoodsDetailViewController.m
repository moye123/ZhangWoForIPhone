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
#import "MyFavoriteViewController.h"
#import "MyMessageViewController.h"

@implementation GoodsDetailViewController
@synthesize goodsid = _goodsid;
@synthesize goodsdata = _goodsdata;
@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"商品详情"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    CGRect frame = self.view.bounds;
    frame.size.height-= 44;
    _webView = [[UIWebView alloc] initWithFrame:frame];
    _webView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.hidden = YES;
    [self.view addSubview:_webView];
    
    CGRect bottomFrame = self.navigationController.toolbar.frame;
    _bottomView = [[GoodsBottomView alloc] initWithFrame:CGRectMake(0, 0, bottomFrame.size.width, bottomFrame.size.height)];
    [_bottomView.cartButton addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.buyButton addTarget:self action:@selector(AddOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:_bottomView];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    _addCartView = [[AddToCartView alloc] init];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=goods&a=showdetail&id=%ld",(long)_goodsid];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    [[DSXHttpManager sharedManager] GET:@"&c=goods&a=showdetail&datatype=json"
                             parameters:@{@"id":@(_goodsid)}
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                        if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                                            _goodsdata = [responseObject objectForKey:@"data"];
                                            _webView.hidden = NO;
                                        }else {
                                            [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleError Message:@"商品不存在或已下架"];
                                            [NSTimer scheduledTimerWithTimeInterval:2
                                                                             target:self
                                                                           selector:@selector(back)
                                                                           userInfo:nil repeats:NO];
                                        }
                                    }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
                                     @"idtype":@"goodsid",
                                     @"title":[_goodsdata objectForKey:@"name"]};
            [[AFHTTPSessionManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=favorite&a=save"] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"收藏成功"];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
        }else {
            [self showLogin];
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

#pragma mark -

- (void)showLogin{
    [[ZWUserStatus sharedStatus] showLoginFromViewController:self];
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

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[DSXUI standardUI] showPopViewWithStyle:DSXPopViewStyleWarning Message:@"请检查网络链接"];
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

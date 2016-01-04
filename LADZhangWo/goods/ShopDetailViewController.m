//
//  ShopDetailViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "MarkMapViewController.h"
#import "GoodsDetailViewController.h"
#import "MyMessageViewController.h"
#import "MyFavoriteViewController.h"

@implementation ShopDetailViewController
@synthesize webView = _webView;
@synthesize shopid = _shopid;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor backColor];
    [self.view addSubview:_webView];
    
    NSURL *shopURL = [NSURL URLWithString:[SITEAPI stringByAppendingFormat:@"&c=shop&a=showdetail&shopid=%ld",(long)_shopid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:shopURL];
    [_webView loadRequest:request];
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
                                     @"dataid":@(_shopid),
                                     @"idtype":@"shopid",
                                     @"title":self.title};
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"zwapp"]) {
        NSDictionary *params = [[DSXUtil sharedUtil] parseQueryString:[url query]];
        NSString *cmd = [url host];
        if ([cmd isEqualToString:@"showmap"]) {
            MarkMapViewController *mapView = [[MarkMapViewController alloc] init];
            mapView.address = [params objectForKey:@"address"];
            [self.navigationController pushViewController:mapView animated:YES];
        }
        if ([cmd isEqualToString:@"showgoods"]) {
            GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
            goodsView.goodsid = [[params objectForKey:@"id"] integerValue];
            [self.navigationController pushViewController:goodsView animated:YES];
        }
    }
    return YES;
}

@end

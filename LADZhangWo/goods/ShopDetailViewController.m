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

@implementation ShopDetailViewController
@synthesize webView = _webView;
@synthesize shopid = _shopid;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor backColor];
    [self.view addSubview:_webView];
    
    NSURL *shopURL = [NSURL URLWithString:[SITEAPI stringByAppendingFormat:@"&mod=shop&ac=showdetail&shopid=%ld",(long)_shopid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:shopURL];
    [_webView loadRequest:request];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
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

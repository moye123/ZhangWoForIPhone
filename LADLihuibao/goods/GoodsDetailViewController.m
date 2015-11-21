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
@synthesize goodsdata;
@synthesize contentWebView = _contentWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"宝贝详情"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _contentWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _contentWebView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _contentWebView.delegate = self;
    [self.view addSubview:_contentWebView];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=goods&ac=showdetail&id=%d",self.goodsid];
    [_contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    //NSLog(@"%@",urlString);
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *jsonString = [_contentWebView stringByEvaluatingJavaScriptFromString:@"getGoods()"];
    id dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self.goodsdata = dictionary;
        //NSLog(@"%@",dictionary);
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
            BuyViewController *buyView = [[BuyViewController alloc] init];
            buyView.goodsid = [[params objectForKey:@"goods_id"] integerValue];
            buyView.goodsdata = self.goodsdata;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

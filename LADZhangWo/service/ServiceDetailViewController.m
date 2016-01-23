//
//  ServiceDetailViewController.m
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "MarkMapViewController.h"

@implementation ServiceDetailViewController
@synthesize serviceID   = _serviceID;
@synthesize serviceData = _serviceData;
@synthesize webView     = _webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=service&a=showdetail&id=%ld",(long)_serviceID];
    [[DSXHttpManager sharedManager] GET:@"&c=service&a=showdetail&datatype=json" parameters:@{@"id":@(_serviceID)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                _serviceData = [responseObject objectForKey:@"data"];
                self.title = [_serviceData objectForKey:@"title"];
                _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
                _webView.backgroundColor = [UIColor backColor];
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
                [self.view addSubview:_webView];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webView delegate

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
    }
    return YES;
}

@end

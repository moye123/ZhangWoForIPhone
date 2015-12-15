//
//  TravelDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelDetailViewController.h"
#import "MarkMapViewController.h"

@implementation TravelDetailViewController
@synthesize travelID;
@synthesize travelData;
@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=travel&ac=showdetail&id=%ld",(long)self.travelID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSDictionary *params = [[DSXUtil sharedUtil] parseQueryString:[url query]];
    if ([[url scheme] isEqualToString:@"zwapp"]) {
        NSString *cmd = [url host];
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

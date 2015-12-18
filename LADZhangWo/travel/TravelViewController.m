//
//  TravelViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelViewController.h"
#import "TravelListViewController.h"
#import "TravelDetailViewController.h"

@implementation TravelViewController
@synthesize webView = _webView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"旅游"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor backColor];
    NSURL *requestURL = [NSURL URLWithString:[SITEAPI stringByAppendingString:@"&mod=travel"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSDictionary *params = [[DSXUtil sharedUtil] parseQueryString:[url query]];
    if ([[url scheme] isEqualToString:@"zwapp"]) {
        NSString *cmd = [url host];
        if ([cmd isEqualToString:@"showdetail"]) {
            TravelDetailViewController *detailView = [[TravelDetailViewController alloc] init];
            detailView.travelID = [[params objectForKey:@"id"] integerValue];
            detailView.title = [params objectForKey:@"title"];
            [self.navigationController pushViewController:detailView animated:YES];
        }
        if ([cmd isEqualToString:@"showmore"]) {
            TravelListViewController *listView = [[TravelListViewController alloc] init];
            listView.title = @"热门景点";
            [self.navigationController pushViewController:listView animated:YES];
        }
        return NO;
    }

    return YES;
}

@end
//
//  WebViewController.m
//  LADZhangWo
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
@synthesize url = _url;
@synthesize webView = _webView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor backColor];
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

@end

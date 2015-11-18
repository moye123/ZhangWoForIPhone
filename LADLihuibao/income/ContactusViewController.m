//
//  ContactusViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ContactusViewController.h"

@implementation ContactusViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"联系我们"];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.backgroundColor = [UIColor backColor];
    [self.view addSubview:webView];
    
    NSString *urlString = [SITEAPI stringByAppendingString:@"&mod=page&ac=showdetail&pageid=15"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webView loadRequest:request];
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

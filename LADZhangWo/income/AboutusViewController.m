//
//  AboutusViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AboutusViewController.h"

@implementation AboutusViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"关于我们"];
    
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor backColor];
    [self.view addSubview:webView];
    
    NSString *urlString = [SITEAPI stringByAppendingString:@"&c=page&a=showdetail&pageid=13"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webView loadRequest:request];
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

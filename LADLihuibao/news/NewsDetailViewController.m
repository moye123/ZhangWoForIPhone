//
//  NewsDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize newsID;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    [self setTitle:@"本地资讯"];
    
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack2 target:self action:@selector(back)];
    UIImage *moreImage = [[UIImage imageNamed:@"icon-more2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:moreImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.mainWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.mainWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainWebView];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=post&ac=showdetail&id=%d",self.newsID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.mainWebView loadRequest:request];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

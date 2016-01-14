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
#import "MyMessageViewController.h"
#import "MyFavoriteViewController.h"

@implementation TravelViewController
@synthesize webView = _webView;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"旅游"];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [DSXUI barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
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
        MyFavoriteViewController *favorView = [[MyFavoriteViewController alloc] init];
        [self.navigationController pushViewController:favorView animated:YES];
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
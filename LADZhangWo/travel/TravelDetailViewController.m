//
//  TravelDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelDetailViewController.h"
#import "MarkMapViewController.h"
#import "MyMessageViewController.h"
#import "MyFavoriteViewController.h"

@implementation TravelDetailViewController
@synthesize travelID   = _travelID;
@synthesize travelData = _travelData;
@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore target:self action:@selector(showPopMenu)];
    //pop菜单
    _popMenu = [[DSXDropDownMenu alloc] initWithFrame:CGRectMake(SWIDTH-110, 60, 100, 140)];
    _popMenu.delegate = self;
    [self.navigationController.view addSubview:_popMenu];
    
    //加载页面数据
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&c=travel&a=showdetail&id=%ld",(long)_travelID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    _webView.delegate = self;
    _webView.hidden = YES;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [[AFHTTPRequestOperationManager sharedManager] GET:[urlString stringByAppendingString:@"&datatype=json"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _travelData = responseObject;
            _webView.hidden = NO;
            self.title = [_travelData objectForKey:@"title"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)back{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        if ([[ZWUserStatus sharedStatus] isLogined]) {
            NSDictionary *params = @{@"uid":@([ZWUserStatus sharedStatus].uid),
                                     @"username":[ZWUserStatus sharedStatus].username,
                                     @"dataid":@(_travelID),
                                     @"idtype":@"travelid",
                                     @"title":[_travelData objectForKey:@"title"]};
            [[AFHTTPRequestOperationManager sharedManager] POST:[SITEAPI stringByAppendingString:@"&c=favorite&a=save"] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    [[DSXUI sharedUI] showPopViewWithStyle:DSXPopViewStyleSuccess Message:@"收藏成功"];
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
        }else {
            [[DSXUI sharedUI] showLoginFromViewController:self];
        }
    }
    
    if ([action isEqualToString:@"showhome"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_popMenu slideUp];
}

#pragma mark - webView delegate
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

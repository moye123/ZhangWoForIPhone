//
//  TravelDetailViewController.m
//  LADLihuibao
//
//  Created by Apple on 15/11/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TravelDetailViewController.h"

@interface TravelDetailViewController ()

@end

@implementation TravelDetailViewController
@synthesize travelID;
@synthesize travelData;
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor backColor]];
    self.navigationItem.leftBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleBack2 target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[DSXUI sharedUI] barButtonWithStyle:DSXBarButtonStyleMore2 target:self action:nil];
    
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=travel&ac=showdetail&id=%d",self.travelID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[urlString stringByAppendingString:@"&datatype=json"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *data = (NSData *)responseObject;
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.travelData = dictionary;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
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

//
//  ShowAdModel.m
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ShowAdModel.h"
#import "GoodsDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ChaoshiDetailViewController.h"
#import "ChaoshiViewController.h"
#import "TravelDetailViewController.h"
#import "NewsDetailViewController.h"
#import "WebViewController.h"
#import "ZWNavigationController.h"

@implementation ShowAdModel

+ (instancetype)sharedModel{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)showAdWithData:(NSDictionary *)data fromViewController:(UIViewController *)vc{
    NSInteger dataid = [[data objectForKey:@"dataid"] integerValue];
    NSString *dataType = [data objectForKey:@"datatype"];
    
    ZWNavigationController *nav;
    if ([dataType isEqualToString:@"goods"]) {
        GoodsDetailViewController *goodsView = [[GoodsDetailViewController alloc] init];
        goodsView.goodsid = dataid;
        goodsView.hidesBottomBarWhenPushed = YES;
        nav = [[ZWNavigationController alloc] initWithRootViewController:goodsView];
    }
    
    if ([dataType isEqualToString:@"shop"]) {
        ShopDetailViewController *shopView = [[ShopDetailViewController alloc] init];
        shopView.shopid = dataid;
        nav = [[ZWNavigationController alloc] initWithRootViewController:shopView];
    }
    
    if ([dataType isEqualToString:@"chaoshigoods"]) {
        ChaoshiDetailViewController *chaoshiDetailView = [[ChaoshiDetailViewController alloc] init];
        chaoshiDetailView.goodsid = dataid;
        chaoshiDetailView.hidesBottomBarWhenPushed = YES;
        nav = [[ZWNavigationController alloc] initWithRootViewController:chaoshiDetailView];
    }
    
    if ([dataType isEqualToString:@"chaoshi"]) {
        ChaoshiViewController *chaoshiView = [[ChaoshiViewController alloc] init];
        chaoshiView.shopid = dataid;
        nav = [[ZWNavigationController alloc] initWithRootViewController:chaoshiView];
    }
    
    if ([dataType isEqualToString:@"travel"]) {
        TravelDetailViewController *travelView = [[TravelDetailViewController alloc] init];
        travelView.travelID = dataid;
        travelView.hidesBottomBarWhenPushed = YES;
        nav = [[ZWNavigationController alloc] initWithRootViewController:travelView];
    }
    
    if ([dataType isEqualToString:@"url"]) {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.urlString = [data objectForKey:@"dataid"];
        nav = [[ZWNavigationController alloc] initWithRootViewController:webView];
    }
    
    if (nav) {
        [nav setStyle:ZWNavigationStyleGray];
        [vc presentViewController:nav animated:YES completion:nil];
    }
}

@end

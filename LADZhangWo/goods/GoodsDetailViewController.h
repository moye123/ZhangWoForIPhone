//
//  GoodsDetailViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "AddToCartView.h"
#import "GoodsBottomView.h"

@interface GoodsDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,DSXDropDownMenuDelegate>{
    @private
    AddToCartView *_addCartView;
    GoodsBottomView *_bottomView;
    DSXDropDownMenu *_popMenu;
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,strong)NSDictionary *goodsdata;
@property(nonatomic,retain)UIWebView *webView;
@end

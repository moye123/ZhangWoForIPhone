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

@interface GoodsDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>{
    @private
    UIButton *_addToCart;
    UIButton *_buyNow;
    AddToCartView *_addCartView;
    GoodsBottomView *_bottomView;
}

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,strong)NSDictionary *goodsdata;
@property(nonatomic,retain)UIWebView *webView;
@end

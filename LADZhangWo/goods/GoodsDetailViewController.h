//
//  GoodsDetailViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
#import "AddToCartView.h"

@interface GoodsDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>{
    @private
    UIButton *_addToCart;
    UIButton *_buyNow;
    UIView *_modalView;
    UIView *_cartView;
    AddToCartView *_addCartView;
}

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,strong)NSDictionary *goodsdata;
@property(nonatomic,retain)UIWebView *contentWebView;
@property(nonatomic,retain)LHBUserStatus *userStatus;
@end

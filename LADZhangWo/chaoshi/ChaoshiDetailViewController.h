//
//  ChaoshiDetailViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "GoodsBottomView.h"
#import "AddToCartView.h"

@interface ChaoshiDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,DSXDropDownMenuDelegate>{
    @private
    UIView *_loadingView;
    GoodsBottomView *_bottomView;
    AddToCartView *_addCartView;
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,strong)NSDictionary *goodsData;
@property(nonatomic,retain)UIWebView *webView;

@end

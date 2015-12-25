//
//  ShopDetailViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/12.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ShopDetailViewController : UIViewController<UIWebViewDelegate,DSXDropDownMenuDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
    AFHTTPRequestOperationManager *_afmanager;
}

@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,assign)NSInteger shopid;

@end

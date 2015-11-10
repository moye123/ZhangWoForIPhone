//
//  GoodsDetailViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"

@interface GoodsDetailViewController : UIViewController

@property(nonatomic,assign)NSInteger goodsid;
@property(nonatomic,strong)NSDictionary *goodsdata;
@property(nonatomic,retain)UIWebView *mainWebView;
@end

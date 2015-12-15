//
//  WebViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *url;
@property(nonatomic,retain)UIWebView *webView;

@end

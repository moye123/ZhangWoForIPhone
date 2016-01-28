//
//  WebViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic)NSString *urlString;
@property(nonatomic)UIWebView *webView;

@end

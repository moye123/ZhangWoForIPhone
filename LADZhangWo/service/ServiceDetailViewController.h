//
//  ServiceDetailViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface ServiceDetailViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic)NSInteger serviceID;
@property(nonatomic)NSDictionary *serviceData;
@property(nonatomic)UIWebView *webView;
@end

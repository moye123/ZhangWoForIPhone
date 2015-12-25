//
//  TravelViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface TravelViewController : UIViewController<UIWebViewDelegate,DSXDropDownMenuDelegate>{
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,retain)UIWebView *webView;

@end

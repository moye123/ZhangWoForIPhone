//
//  ChaoshiViewController.h
//  LADZhangWo
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
@interface ChaoshiViewController : UIViewController<UIWebViewDelegate,DSXDropDownMenuDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,assign)NSInteger shopid;
@property(nonatomic,retain)UIWebView *webView;
@end

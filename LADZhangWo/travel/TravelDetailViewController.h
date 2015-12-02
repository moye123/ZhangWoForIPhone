//
//  TravelDetailViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface TravelDetailViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,assign)int travelID;
@property(nonatomic,strong)NSDictionary *travelData;
@property(nonatomic,retain)UIWebView *contentWebView;

@end

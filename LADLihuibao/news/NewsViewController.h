//
//  NewsViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBCommon.h"
#import "NewsColumnView.h"
#import "NewsListView.h"

@interface NewsViewController : UIViewController<NewsListDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *columns;
@property(nonatomic,retain)NewsColumnView *columnView;
@property(nonatomic,retain)UIScrollView *mainScrollView;
@property(nonatomic,retain)UIToolbar *toolbar;
@property(nonatomic,strong)NSMutableArray *columnButtons;

@end

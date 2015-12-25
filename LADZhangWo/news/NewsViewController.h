//
//  NewsViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "NewsColumnView.h"
#import "NewsListView.h"

@interface NewsViewController : UIViewController<NewsListDelegate,UIScrollViewDelegate,DSXDropDownMenuDelegate>{
    @private
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,strong)NSArray *columns;
@property(nonatomic,retain)NewsColumnView *columnView;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIToolbar *toolbar;
@property(nonatomic,strong)NSMutableArray *columnButtons;
@property(nonatomic,retain)UIScrollView *navView;

@end

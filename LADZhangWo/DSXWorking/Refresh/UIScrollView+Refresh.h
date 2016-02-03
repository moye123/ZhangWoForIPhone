//
//  UIScrollView+Refresh.h
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXRefreshControl.h"

@interface UIScrollView (Refresh)

@property(nonatomic)DSXRefreshHeader *dsx_headerView;
@property(nonatomic)DSXRefreshFooter *dsx_footerView;
@property(nonatomic)DSXRefreshControl *dsx_refreshControl;

@end

//
//  ServiceListViewController.h
//  LADZhangWo
//
//  Created by Apple on 16/1/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemCell.h"

@interface ServiceListViewController : UITableViewController<UIScrollViewDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    DSXRefreshControl *_refreshControl;
    DSXPullUpView *_pullUpView;
    UIView *_noaccessView;
}

@property(nonatomic)NSInteger catid;
@property(nonatomic)NSMutableArray *serviceList;
@end

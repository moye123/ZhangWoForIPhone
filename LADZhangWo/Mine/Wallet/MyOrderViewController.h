//
//  MyOrderViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemCell.h"
#import "OrderCommonCell.h"

@interface MyOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DSXDropDownMenuDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    UILabel *_tipsView;
    DSXDropDownMenu *_popMenu;
    DSXPullUpView *_pullUpView;
    DSXRefreshControl *_refreshControl;
}

@property(nonatomic,strong)NSMutableArray *orderList;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSString *orderStatus;
@property(nonatomic,strong)NSString *payStatus;
@property(nonatomic,strong)NSString *shippingStatus;
@property(nonatomic,strong)NSString *evaluateStatus;

@end

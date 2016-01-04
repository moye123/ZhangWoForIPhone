//
//  CartViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "CartCustomCell.h"

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CartCustomCellDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
    UIButton *_checkAll;
    UILabel *_totaLabel;
    float _totalValue;
    NSInteger _totalNum;
    UIButton *_settlement;
    NSMutableArray *_shopBoxs;
    NSMutableArray *_goodsModelArray;
}

@property(nonatomic,strong)NSMutableArray *cartList;
@property(nonatomic,retain)UITableView *tableView;

@end

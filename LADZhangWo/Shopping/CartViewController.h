//
//  CartViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "CartTitleCell.h"
#import "CartCustomCell.h"
#import "GoodsManager.h"

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CartCustomCellDelegate,CartTitleCellDelegate,DSXRefreshDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    UIButton *_checkAll;
    UILabel *_totaLabel;
    float _totalValue;
    NSInteger _totalNum;
    UIButton *_settlement;
    NSMutableArray *_goodsModelArray;
    NSArray *_moreData;
}

@property(nonatomic,strong)NSMutableArray *cartList;
@property(nonatomic,retain)UITableView *tableView;

@end

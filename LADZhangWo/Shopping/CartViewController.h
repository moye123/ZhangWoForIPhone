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

@interface CartViewController : DSXTableViewController<UITableViewDelegate,UITableViewDataSource,UIToolbarDelegate,CartCustomCellDelegate,CartTitleCellDelegate>{
    @private
    UIButton *_checkAll;
    UILabel *_totaLabel;
    float _totalValue;
    NSInteger _totalNum;
    UIButton *_settlement;
    NSMutableArray *_goodsModelArray;
}

@property(nonatomic,readonly)UIToolbar *toolbar;

@end

//
//  MyBillViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillItemCell.h"

@interface MyBillViewController : UITableViewController<DSXRefreshDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    UILabel *_tipsView;
}

@property(nonatomic,strong)NSMutableArray *billList;

@end

//
//  MyIncomeViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface MyIncomeViewController : UITableViewController<UIScrollViewDelegate,DSXRefreshDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    UILabel *_tipsView;
}

@property(nonatomic,strong)NSMutableArray *incomeList;

@end

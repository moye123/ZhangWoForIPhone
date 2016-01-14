//
//  GoodsListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsItemCell.h"

@interface GoodsListViewController : UITableViewController<UIScrollViewDelegate,DSXDropDownMenuDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
    DSXDropDownMenu *_popMenu;
}

@property(nonatomic,assign)NSInteger catid;
@property(nonatomic,strong)NSMutableArray *goodsList;

@end

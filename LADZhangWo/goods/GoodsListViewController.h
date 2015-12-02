//
//  GoodsListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/10/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "DSXStarView.h"

@interface GoodsListViewController : UITableViewController<UIScrollViewDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
}

@property(nonatomic,assign)int catid;
@property(nonatomic,strong)NSMutableArray *goodsArray;

@end

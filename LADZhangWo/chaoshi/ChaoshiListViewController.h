//
//  ChaoshiListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"
#import "DSXStarView.h"
#import "ChaoshiGoodsItemCell.h"
#import "LeftMenuView.h"

@interface ChaoshiListViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,DSXDropDownMenuDelegate,DSXRefreshDelegate,LeftMenuViewDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    UILabel *_tipsView;
    DSXDropDownMenu *_popMenu;
    LeftMenuView *_leftMenu;
}

@property(nonatomic,assign)NSInteger catid;
@property(nonatomic,assign)NSInteger shopid;
@property(nonatomic,strong)NSMutableArray *goodsList;
@property(nonatomic)UITableView *menuView;
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)UIToolbar *toolbar;
@property(nonatomic,readonly)DSXRefreshControl *refreshControl;

@end

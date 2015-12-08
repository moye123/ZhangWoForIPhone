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

@interface ChaoshiListViewController : UICollectionViewController<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>{
@private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
    AFHTTPRequestOperationManager *_afmanager;
    CGFloat _cellWith;
    CGFloat _cellHeight;
    UILabel *_tipsView;
}

- (instancetype)init;

@property(nonatomic,assign)NSInteger catid;
@property(nonatomic,assign)NSInteger shopid;
@property(nonatomic,strong)NSMutableArray *goodsList;

@end

//
//  TravelListViewController.h
//  LADLihuibao
//
//  Created by Apple on 15/11/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCommon.h"

@interface TravelListViewController : UITableViewController<UIScrollViewDelegate,DSXDropDownMenuDelegate,DSXRefreshDelegate>{
@private
    int _page;
    BOOL _isRefreshing;
    UILabel *_tipsLabel;
    DSXDropDownMenu *_popMenu;
}
@property(nonatomic,strong)NSMutableArray *travelList;
@property(nonatomic,assign)NSInteger catid;

@end

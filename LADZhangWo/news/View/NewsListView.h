//
//  NewsListView.h
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItemCell.h"

@protocol NewsListDelegate <NSObject>

@optional
- (void)showNewsDetailWithID:(NSInteger)newsID;

@end

@interface NewsListView : UITableView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    ZWRefreshControl *_refreshControl;
    ZWPullUpView *_pullUpView;
}
@property(nonatomic,assign)int catid;
@property(nonatomic,strong)NSMutableArray *newsArray;
@property(nonatomic,assign)id<NewsListDelegate>showNewsDelegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showTableView;

@end

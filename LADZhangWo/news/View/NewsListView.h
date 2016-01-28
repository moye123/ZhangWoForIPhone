//
//  NewsListView.h
//  LADLihuibao
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItemCell.h"
#import "NewsSliderView.h"
@class NewsListView;
@protocol NewsListDelegate <NSObject>
@optional
- (void)listView:(NewsListView *)listView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data;

@end

@interface NewsListView : UITableView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DSXRefreshDelegate>{
    @private
    int _page;
    BOOL _isRefreshing;
    NSMutableArray *_newsList;
    NSArray *_moreData;
}
@property(nonatomic,assign)int catid;
@property(nonatomic,readonly)NewsSliderView *sliderView;
@property(nonatomic,assign)id<NewsSliderViewDelegate,NewsListDelegate>showDetailDelegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;

@end

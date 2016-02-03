//
//  DSXRefreshControl.h
//  LADZhangWo
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSXRefreshHeader.h"
#import "DSXRefreshFooter.h"

@interface DSXRefreshControl : NSObject

@property(nonatomic,readonly)DSXRefreshHeader *headerView;
@property(nonatomic,readonly)DSXRefreshFooter *footerView;
@property(nonatomic,readwrite)DSXRefreshState refreshState;
@property(nonatomic,readwrite)DSXLoadingState loadingState;
@property(nonatomic,assign)BOOL bottomHidden;
@property(nonatomic,assign)id<DSXRefreshDelegate>delegate;

- (instancetype)init;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)beginLoading;
- (void)endLoading;

@end

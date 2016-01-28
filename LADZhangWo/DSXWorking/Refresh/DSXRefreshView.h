//
//  DSXRefreshView.h
//  LADZhangWo
//
//  Created by Apple on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Size.h"

UIKIT_EXTERN CGFloat const DSXRefreshHeaderHeight;
UIKIT_EXTERN CGFloat const DSXRefreshFooterHeight;
UIKIT_EXTERN NSString *const DSXRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const DSXRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const DSXRefreshKeyPathPanState;

@class DSXRefreshView;
@protocol DSXRefreshDelegate <NSObject>
@optional
- (void)willStartRefreshing:(DSXRefreshView *)refreshView;
- (void)didStartRefreshing:(DSXRefreshView *)refreshView;
- (void)didEndRefreshing:(DSXRefreshView *)refreshView;
- (void)willStartLoading:(DSXRefreshView *)refreshView;
- (void)didStartLoading:(DSXRefreshView *)refreshView;
- (void)didEndLoading:(DSXRefreshView *)refreshView;

@end

@interface DSXRefreshView : UIView

@property(nonatomic)UIPanGestureRecognizer *pan;
@property(nonatomic,readonly)UILabel *textLabel;
@property(nonatomic,readonly)UIActivityIndicatorView *indicatorView;
@property(nonatomic,readonly)UIScrollView *scrollView;
@property(nonatomic,readonly)UIEdgeInsets scrollViewOriginInset;
@property(nonatomic,assign)id<DSXRefreshDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

@end

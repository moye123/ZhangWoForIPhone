//
//  DSXRefreshFooter.h
//  LADZhangWo
//
//  Created by Apple on 16/1/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DSXRefreshView.h"

typedef NS_ENUM(NSInteger,DSXLoadingState) {
    DSXLoadingStateNormal,
    DSXLoadingStateWillLoading,
    DSXLoadingStateLoading,
    DSXLoadingStateNoMoreData
};

UIKIT_EXTERN NSString *const DSXLoadingStateNormalText;
UIKIT_EXTERN NSString *const DSXLoadingStateWillLoadingText;
UIKIT_EXTERN NSString *const DSXLoadingStateLoadingText;
UIKIT_EXTERN NSString *const DSXLoadingStateNoMoreDataText;

@interface DSXRefreshFooter : DSXRefreshView

@property(nonatomic,readonly)BOOL isLoading;
@property(nonatomic,readwrite)DSXLoadingState loadingState;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)beginLoading;
- (void)endLoading;

@end

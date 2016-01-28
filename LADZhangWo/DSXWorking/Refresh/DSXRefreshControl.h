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
#import "UIScrollView+Refresh.h"

@interface DSXRefreshControl : NSObject

@property(nonatomic,readonly)DSXRefreshHeader *headerView;
@property(nonatomic,readonly)DSXRefreshFooter *footerView;
@property(nonatomic)UIScrollView *scrollView;
@property(nonatomic)id<DSXRefreshDelegate>delegate;

- (instancetype)init;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@end
